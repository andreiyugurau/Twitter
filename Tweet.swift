//
//  Tweet.swift
//  Twitter
//
//  Created by Andrei Gurau on 2/7/16.
//  Copyright © 2016 Andrei Gurau. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favorites: Int?
    var id: Int?
    var retweets: Int?
    
 
    init(dictionary: NSDictionary)
    {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        favorites = dictionary["favorite_count"] as? Int
        retweets = dictionary["retweet_count"] as? Int
        
        id = dictionary["id"] as? Int
    }
    class func tweetswithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    class func favoriteTweet(){
        
    }
}
