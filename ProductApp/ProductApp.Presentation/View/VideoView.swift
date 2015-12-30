//
//  VideoView.swift
//  GamingStreamsTVApp
//
//  Created by Gabriel Petrescu on 12/22/15.
//  Copyright © 2015 OwnZones. All rights reserved.

import UIKit
import AVFoundation
import Foundation

class VideoView : UIView {
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.classForCoder()
    }
    
    func getPlayer() -> AVPlayer? {
        let layer = self.layer as! AVPlayerLayer
        return layer.player
    }
    
    func setPlayer(player : AVPlayer?) {
        let layer = self.layer as! AVPlayerLayer
        layer.player = player
    }
    
    func setVideoFillMode(fillMode : String) {
        let layer = self.layer as! AVPlayerLayer
        layer.videoGravity = fillMode
    }
}