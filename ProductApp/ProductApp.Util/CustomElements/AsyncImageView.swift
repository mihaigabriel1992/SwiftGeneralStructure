//
//  AsyncImageView.swift
//  SwiftGeneralStructure
//
//  Created by Gabriel Petrescu on 12/21/15.
//  Copyright © 2015 OwnZones. All rights reserved.
//

import UIKit

class AsyncImage: UIImageView {

    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        print("Started downloading \"\(url.URLByDeletingPathExtension!.lastPathComponent!)\".")
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print("Finished downloading \"\(url.URLByDeletingPathExtension!.lastPathComponent!)\".")
                self.image = UIImage(data: data)
            }
        }
    }
}
