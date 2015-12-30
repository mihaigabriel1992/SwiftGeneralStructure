//
//  ViewController.swift
//  ProductApp
//
//  Created by Gabriel Petrescu on 12/21/15.
//  Copyright © 2015 OwnZones. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import AVFoundation

class MainViewController: UIViewController{    
    //Outlets
    @IBOutlet var collectionView : UICollectionView!
    
    //Global Variables
    private var avPlayerLayer : AVPlayerLayer!
    private let listOfItems = ["1.jpg", "2.jpg", "3.jpg", "4.jpg", "5.jpg"]
    private let streams = [
        OwnzoneStream(id: 1, gameName: "Test", viewers: 10, videoHeight: 200, preview: ["Test" : "Test"]),
        OwnzoneStream(id: 1, gameName: "Test", viewers: 10, videoHeight: 200, preview: ["Test" : "Test"]),
        OwnzoneStream(id: 1, gameName: "Test", viewers: 10, videoHeight: 200, preview: ["Test" : "Test"]),
        OwnzoneStream(id: 1, gameName: "Test", viewers: 10, videoHeight: 200, preview: ["Test" : "Test"]),
        OwnzoneStream(id: 1, gameName: "Test", viewers: 10, videoHeight: 200, preview: ["Test" : "Test"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0.4, alpha: 1)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        doRequest ()
//        doPostRequest ()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Request methods
    private func doRequest (){
        let URL = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
        Alamofire.request(.GET, URL).responseObject { (response: Response<WeatherResponse, NSError>) in
            
            let weatherResponse = response.result.value
            print(weatherResponse?.location)
            
            if let threeDayForecast = weatherResponse?.threeDayForecast {
                for forecast in threeDayForecast {
                    print(forecast.day)
                    print(forecast.temperature)
                }
            }
        }
    }
    
    private func doPostRequest(){
        let URL = "https://httpbin.org/post"
        
        let subObject = PostRequest ("test")
        
        Alamofire.request(.POST, URL, parameters: subObject.toJSONObject(), encoding: .JSON).responseObject { (response: Response<PostResponse, NSError>) in
            
            let postResponse = response.result.value
            print(postResponse?.origin)
            
        }
    }
    
    //MARK: Press buttons delegates
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press : UIPress in presses{
            if press.type == UIPressType.PlayPause{
                if(avPlayerLayer?.player!.rate != 0){
                    avPlayerLayer?.player!.pause()
                }else{
                    avPlayerLayer?.player!.play()
                }
            }else if press.type == UIPressType.Menu{
                avPlayerLayer?.removeFromSuperlayer()
                avPlayerLayer?.player!.pause()
            }
            
        }
    }
    
    //MARK: Private methods
    func getItemAtIndex(index: Int) -> CellItem {
        return OwnzoneStream(id: 1, gameName: "Test", viewers: 10, videoHeight: 200, preview: ["Test" : "Test"])
    }
    
    private func showImagePopover(imageName : String){
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let imageVC = UIViewController()
        imageVC.view = imageView
        
        self.presentViewController(imageVC, animated: true, completion: nil)
    }
    
    private func playVideo (){
        let avPlayer = AVPlayer(URL: NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        
        avPlayerLayer!.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.layer.addSublayer(avPlayerLayer!)
        avPlayer.play()
    }
    
    private func viewPDF (){
        let avPlayer = AVPlayer(URL: NSURL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        
        avPlayerLayer!.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.layer.addSublayer(avPlayerLayer!)
        avPlayer.play()
    }
}

//////////////////////////////////////////////
// MARK: UICollectionViewDataSource interface
//////////////////////////////////////////////

extension MainViewController : UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return streams.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : ItemCellView = collectionView.dequeueReusableCellWithReuseIdentifier(ItemCellView.CELL_IDENTIFIER, forIndexPath: indexPath) as! ItemCellView
        cell.setRepresentedItem(self.getItemAtIndex(indexPath.row))
        return cell
    }
}

//////////////////////////////////////////////////////
// MARK: UICollectionViewDelegateFlowLayout interface
//////////////////////////////////////////////////////

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//            let width = collectionView.bounds.width / CGFloat(NUM_COLUMNS) - CGFloat(ITEMS_INSETS_X * 2)
//            let height = width * HEIGHT_RATIO + (ItemCellView.LABEL_HEIGHT * 2) //There 2 labels, top & bottom
//            
//            return CGSize(width: width, height: height)
//    }
//
//    func collectionView(collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//            return UIEdgeInsets(top: ITEMS_INSETS_Y, left: ITEMS_INSETS_X, bottom: ITEMS_INSETS_Y, right: ITEMS_INSETS_X)
//    }
    
}

////////////////////////////////////////////
// MARK: UICollectionViewDelegate interface
////////////////////////////////////////////

extension MainViewController : UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            let selectedStream = streams[indexPath.row]
            let videoViewController = StreamVideoViewController(stream: selectedStream)
            
            self.presentViewController(videoViewController, animated: true, completion: nil)
        } else if indexPath.row == 1{
            self.playVideo()
        }else{
            self.showImagePopover(listOfItems[indexPath.row])
        }
    }
    
}

