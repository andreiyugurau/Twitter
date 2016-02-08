//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Andrei Gurau on 2/7/16.
//  Copyright © 2016 Andrei Gurau. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil , completion:{ (tweets, error) -> () in
        self.tweets = tweets
            self.tableView.reloadData()
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        //if let a = tweets?[indexPath.row]
        //{
        
        
        cell.tweetLabel.text = tweets?[indexPath.row].text
        cell.nameLabel.text = tweets?[indexPath.row].user?.name
        cell.timestampLabel.text = tweets?[indexPath.row].createdAtString
        if let a = tweets?[indexPath.row].user?.profileImageUrl
        {
        print("profile pic url \(tweets?[indexPath.row].user?.profileImageUrl)")
        //cell.profilePicLabel.setImageWithURL(tweets?[indexPath.row].user?.profileImageUrl)
        //cell.profilePicLabel.setImageWithURL(myTweet?.user?.profileImageUrl as NSURL)
        
        
        
        let baseUrl = tweets?[indexPath.row].user?.profileImageUrl
        let imageUrl = NSURL(string: (baseUrl)!)
        cell.profilePicLabel.setImageWithURL((imageUrl)!)
        
        
        }
        
        //}
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
