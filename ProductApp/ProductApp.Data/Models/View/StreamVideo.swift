//
//  TwitchStream.swift
//  TestTVApp
//
//  Created by Gabriel Petrescu on 12/22/15.
//  Copyright © 2015 OwnZones. All rights reserved.

import Foundation

struct StreamVideo {
    var quality : String
    var url : NSURL
    var codecs : String
    
    init (quality: String, url : NSURL, codecs : String){
        self.quality = quality
        self.url = url
        self.codecs = codecs
    }
}