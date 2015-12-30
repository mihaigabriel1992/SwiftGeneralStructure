//
//  TwitchStream.swift
//  TestTVApp
//
//  Created by Gabriel Petrescu on 12/22/15.
//  Copyright © 2015 OwnZones. All rights reserved.

import Foundation
import UIKit

struct OwnzoneStream: CellItem {
    let id : Int!
    let gameName : String!
    let viewers : Int!
    let videoHeight : Int!
    let preview : [String : String]!
    var mImage: UIImage?
    
    init(id : Int, gameName : String, viewers : Int, videoHeight : Int, preview : [String : String]) {
        self.id = id
        self.gameName = gameName
        self.viewers = viewers
        self.videoHeight = videoHeight
        self.preview = preview
    }
    
    init?(dict: [String : AnyObject]) {
        guard let id = dict["_id"] as? Int else {
            return nil
        }
        
        guard let gameName = dict["game"] as? String else {
            return nil
        }
        
        guard let preview = dict["preview"] as? [String : String] else {
            return nil
        }
        
        self.id = id
        self.gameName = gameName
        self.preview = preview
        
        if let viewers = dict["viewers"] as? Int {
            self.viewers = viewers
        }
        else {
            self.viewers = 0
        }
        
        if let videoHeight = dict["video_height"] as? Int {
            self.videoHeight = videoHeight
        }
        else {
            self.videoHeight = 0
        }
        
    }
    
    var urlTemplate: String? {
        get {
            return preview["large"]
        }
    }
    
    var title: String {
        get {
            return "Title"
        }
    }
    
    var subtitle: String {
        get {
            return "\(12) viewers on Channel Name"
        }
    }
    
    var bannerString: String? {
        get {
            return "Display Language"
        }
    }
    
    var image: UIImage? {
        get {
            return mImage
        }
    }
    
    mutating func setImage(image: UIImage) {
        mImage = image
    }
}
