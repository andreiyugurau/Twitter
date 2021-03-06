//
//  Twitter Client.swift
//  Twitter
//
//  Created by Andrei Gurau on 2/2/16.
//  Copyright © 2016 Andrei Gurau. All rights reserved.
//
import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "7NWq9oRtGtA0bJZ7WgSzSr4u3"
let twitterConsumerSecret = "gLlYCkYDDkzPlkiKExodkQnubKq5MmnHUjVFtfbsDkQV1YDN5W"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                print("Error getting request token: \(error)")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    func openURL(url: NSURL)
    {
        
        
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got access token")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            let manager = AFHTTPSessionManager()
            
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("It worked!!!")
                //print("user: \(response)")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("It did not work")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            
            })
            { (error: NSError!) -> Void in
                print("An error occurred")
                self.loginCompletion?(user: nil, error: error)
        }

    }
    
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ())
    {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject!) -> Void in
            print("home timeline: \(response)")
            var tweets = Tweet.tweetswithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("It did not work for home timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    func favorite(id: String)
    {
        POST("https://api.twitter.com/1.1/favorites/create.json?id=\(id)", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("favorited")
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to favorite")
        }
    }
    func unfavorite(id: String) {
        POST("https://api.twitter.com/1.1/favorites/destroy.json?id=\(id)", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("unfavorited")
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to unfavorite")
        }
    }
    
    func retweet(id: String) {
        POST("https://api.twitter.com/1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("retweeted")
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to retweet")
        }
    }
    func unretweet(id: String) {
        POST("https://api.twitter.com/1.1/statuses/unretweet/\(id).json", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("unretweeted")
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("unretweet")
        }
    }
    
    func test(message: String)
    {
        var newString = message.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        newString = newString.stringByReplacingOccurrencesOfString("'", withString: "%27", options: NSStringCompareOptions.LiteralSearch, range: nil)
        newString = newString.stringByReplacingOccurrencesOfString("#", withString: "%23", options: NSStringCompareOptions.LiteralSearch, range: nil)
        newString = newString.stringByReplacingOccurrencesOfString("@", withString: "%40", options: NSStringCompareOptions.LiteralSearch, range: nil)
        print("https://api.twitter.com/1.1/statuses/update.json?status=\(newString)")
        POST("https://api.twitter.com/1.1/statuses/update.json?status=\(newString)", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("post")
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("didn't post")
        }
    }
    func reply(message: String, username: String)
    {
        var newString = message.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        newString = newString.stringByReplacingOccurrencesOfString("'", withString: "%27", options: NSStringCompareOptions.LiteralSearch, range: nil)
        newString = newString.stringByReplacingOccurrencesOfString("#", withString: "%23", options: NSStringCompareOptions.LiteralSearch, range: nil)
        newString = newString.stringByReplacingOccurrencesOfString("@", withString: "%40", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var finalString = "%40\(username)%20\(newString)"
        print("https://api.twitter.com/1.1/statuses/update.json?status=\(finalString)")
        POST("https://api.twitter.com/1.1/statuses/update.json?status=\(finalString)", parameters: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("replied")
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("didn't replied")
        }
    }
    
}