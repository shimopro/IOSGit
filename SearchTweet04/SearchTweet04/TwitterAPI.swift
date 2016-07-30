//
//  TwitterAPI.swift
//  SearchIQON
//
//  Created by 下東祐太 on 2016/07/30.
//  Copyright © 2016年 shimopro. All rights reserved.
//

import Foundation
import TwitterKit
import Fabric

class TwitterAPI {
    let baseURL = "https://api.twitter.com"
    let version = "/1.1"
    
    init() {
        
    }
    
    
    
    class func search(params: [NSObject : AnyObject]!, tweets: [TWTRTweet]->(), error: (NSError) -> ()) {
        let api = TwitterAPI()
        let client = TWTRAPIClient()
        let path = "/search/tweets.json"
        let endpoint = api.baseURL + api.version + path
//        let params = ["q": "iQON", "lang": "ja", "count": "1000"]
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: endpoint, parameters: params, error: &clientError)
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                print("json: \(json)")
                if let statuses = json["statuses"] as? NSArray {
                    let twArray = TWTRTweet.tweetsWithJSONArray(statuses as [AnyObject]) as! [TWTRTweet]
                    tweets(twArray)
                }
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
}

