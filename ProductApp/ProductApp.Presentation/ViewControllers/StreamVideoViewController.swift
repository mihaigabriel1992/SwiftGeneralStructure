//
//  TwitchVideoViewController.swift
//  GamingStreamsTVApp
//
//  Created by Gabriel Petrescu on 12/21/15.
//  Copyright © 2015 OwnZones. All rights reserved.
//
import AVKit
import UIKit
import Foundation

enum StreamSourceQuality: String {
    case Source
    case High
    case Medium
    case Low
}

class StreamVideoViewController : UIViewController {
    private var videoView : VideoView?
    private var videoPlayer : AVPlayer?
    private var streams : [StreamVideo]?
    private var currentStream : OwnzoneStream?
    private var currentStreamVideo: StreamVideo?
    private var modalMenu : ModalMenuView?
    private var modalMenuOptions : [String : [MenuOption]]?
    
    private var leftSwipe: UISwipeGestureRecognizer!
    private var rightSwipe: UISwipeGestureRecognizer!
    
    private var hardcodedStream = "http://video-edge-6ea020.lhr02.hls.ttvnw.net/hls-8559c8/girlstorule_18556631856_373119554/chunked/py-index-live.m3u8?token=id=6938582833229477457,bid=18556631856,exp=1451568250,node=video-edge-6ea020-1.lhr02.hls.justin.tv,nname=video-edge-6ea020.lhr02,fmt=chunked&sig=8ca5edc2fa0ad6ea65166026b157c21498dd28f2"
    
    /*
    * init(stream : TwitchStream)
    *
    * Initializes the controller, it's gesture recognizer and modal menu.
    * Loads and prepare the video asset from the stream for display
    */
    convenience init(stream : OwnzoneStream){
        self.init(nibName: nil, bundle: nil)
        self.currentStream = stream
        
        self.view.backgroundColor = UIColor.blackColor()
        
        //Gestures configuration
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPress:"))
        longPressRecognizer.cancelsTouchesInView = true
        self.view.addGestureRecognizer(longPressRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "pause")
        tapRecognizer.allowedPressTypes = [NSNumber(integer: UIPressType.PlayPause.rawValue)]
        self.view.addGestureRecognizer(tapRecognizer)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "handleMenuPress")
        gestureRecognizer.allowedPressTypes = [UIPressType.Menu.rawValue]
        gestureRecognizer.cancelsTouchesInView = true
        self.view.addGestureRecognizer(gestureRecognizer)
        
        leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("swipe:"))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(leftSwipe)
        
        rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("swipe:"))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        rightSwipe.enabled = false
        self.view.addGestureRecognizer(rightSwipe)
            
        //Modal menu options
        self.modalMenuOptions = [
            "Stream Quality" : [
                MenuOption(title: StreamSourceQuality.Source.rawValue, enabled: false, onClick: self.handleQualityChange),
                MenuOption(title: StreamSourceQuality.High.rawValue, enabled: false, onClick: self.handleQualityChange),
                MenuOption(title: StreamSourceQuality.Medium.rawValue, enabled: false, onClick: self.handleQualityChange),
                MenuOption(title: StreamSourceQuality.Low.rawValue, enabled: false, onClick: self.handleQualityChange)
            ]
        ]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        streams = [
            StreamVideo (quality: "chunked", url: NSURL(string: hardcodedStream.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
                , codecs: "avc1.4D4029,mp4a.40.2")
        ]
        
        if let streams = streams where streams.count > 0 {
            self.streams = streams
            self.currentStreamVideo = streams[0]
            let streamAsset = AVURLAsset(URL: self.currentStreamVideo!.url)
            let streamItem = AVPlayerItem(asset: streamAsset)
            
            self.videoPlayer = AVPlayer(playerItem: streamItem)
            
            dispatch_async(dispatch_get_main_queue(),{
                self.initializePlayerView()
            })
        }
    }
    
    /*
    * viewWillDisappear(animated: Bool)
    *
    * Overrides the default method to shut off the chat connection if present
    * and the free video assets
    */
    override func viewWillDisappear(animated: Bool) {
        
        self.videoView?.removeFromSuperview()
        self.videoView?.setPlayer(nil)
        self.videoView = nil
        self.videoPlayer = nil

        super.viewWillDisappear(animated)
    }
    
    /*
    * initializePlayerView()
    *
    * Initializes a player view with the current video player
    * and displays it
    */
    func initializePlayerView() {
        self.videoView = VideoView(frame: self.view.bounds)
        self.videoView?.setPlayer(self.videoPlayer!)
        self.videoView?.setVideoFillMode(AVLayerVideoGravityResizeAspect)
        
        self.view.addSubview(self.videoView!)
        self.videoPlayer?.play()
    }
    
    /*
    * handleLongPress()
    *
    * Handler for the UILongPressGestureRecognizer of the controller
    * Presents the modal menu if it is initialized
    */
    func handleLongPress(longPressRecognizer: UILongPressGestureRecognizer) {
        if longPressRecognizer.state == UIGestureRecognizerState.Began {
            if self.modalMenu == nil {
                modalMenu = ModalMenuView(frame: self.view.bounds,
                    options: self.modalMenuOptions!,
                    size: CGSize(width: self.view.bounds.width/3, height: self.view.bounds.height/1.5))
                
                modalMenu!.center = self.view.center
            }
            
            guard let modalMenu = self.modalMenu else {
                return
            }
            
            if modalMenu.isDescendantOfView(self.view) {
                dismissMenu()
            } else {
                modalMenu.alpha = 0
                self.view.addSubview(self.modalMenu!)
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.modalMenu?.alpha = 1
                    self.view.setNeedsFocusUpdate()
                })
            }
        }
    }
    
    /*
    * handleMenuPress()
    *
    * Handler for the UITapGestureRecognizer of the modal menu
    * Dismisses the modal menu if it is present
    */
    func handleMenuPress() {
        if dismissMenu() {
            return
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissMenu() -> Bool {
        if let modalMenu = modalMenu {
            if self.view.subviews.contains(modalMenu) {
                //bkirchner: for some reason when i try to animate the menu fading away, it just goes to the homescreen - really odd
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    modalMenu.alpha = 0
                }, completion: { (finished) -> Void in
                    if finished {
                        modalMenu.removeFromSuperview()
                    }
                })
//                modalMenu.removeFromSuperview()
                return true
            }
        }
        return false
    }
    
    func handleQualityChange(sender : MenuItemView?) {
        if let text = sender?.title?.text, quality = StreamSourceQuality(rawValue: text) {
            var qualityIdentifier = "chunked"
            switch quality {
            case .Source:
                qualityIdentifier = "chunked"
            case .High:
                qualityIdentifier = "high"
            case .Medium:
                qualityIdentifier = "medium"
            case .Low:
                qualityIdentifier = "low"
            }
            if let streams = self.streams {
                for stream in streams {
                    if stream.quality == qualityIdentifier {
                        currentStreamVideo = stream
                        let streamAsset = AVURLAsset(URL: stream.url)
                        let streamItem = AVPlayerItem(asset: streamAsset)
                        self.videoPlayer?.replaceCurrentItemWithPlayerItem(streamItem)
                        dismissMenu()
                        return
                    }
                }
            }
        }
    }
    
    func pause() {
        if let player = self.videoPlayer {
            if player.rate == 1 {
                player.pause()
            } else {
                if let currentVideo = currentStreamVideo {
                    //do this to bring it back in sync
                    let streamAsset = AVURLAsset(URL: currentVideo.url)
                    let streamItem = AVPlayerItem(asset: streamAsset)
                    player.replaceCurrentItemWithPlayerItem(streamItem)
                }
                player.play()
            }
        }
    }
}
