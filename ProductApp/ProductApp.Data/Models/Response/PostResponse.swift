//
//  PostResponse.swift
//  SwiftGeneralStructure
//
//  Created by Gabriel Petrescu on 12/21/15.
//  Copyright © 2015 OwnZones. All rights reserved.
//

import Foundation
import ObjectMapper

class PostResponse: Mappable {
    var json: SubObject?
    var data: String?
    var origin: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        json <- map["json"]
        data <- map["data"]
        origin <- map["origin"]
    }
}

class SubObject: Mappable {
    var Msisdn: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        Msisdn <- map["Msisdn"]
    }
}