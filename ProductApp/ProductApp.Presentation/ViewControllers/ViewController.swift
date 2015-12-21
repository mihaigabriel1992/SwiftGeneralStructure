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

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        doRequest ()
        doPostRequest ()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
}

