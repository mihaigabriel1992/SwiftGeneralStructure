//
//  PostRequest.swift
//  SwiftGeneralStructure
//
//  Created by Gabriel Petrescu on 12/16/15.
//  Copyright © 2015 Gabriel Petrescu. All rights reserved.
//

import Foundation
import ObjectMapper

class PostRequest: Mappable {
    var Msisdn: String?
    
    init (_ parameter: String){
        self.Msisdn = parameter;
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        Msisdn <- map["Msisdn"]
    }
    
    func toJSONObject() -> [String : AnyObject]{
        return Mapper().toJSON(self)
    }
}