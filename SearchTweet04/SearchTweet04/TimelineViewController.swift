//
//  TimelineViewController.swift
//  SearchTweet04
//
//  Created by 下東祐太 on 2016/07/30.
//  Copyright © 2016年 shimopro. All rights reserved.
//

import UIKit
import TwitterKit
import Fabric

class TimelineViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var tweets: [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var prototypeCell: TWTRTweetTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        
        prototypeCell = TWTRTweetTableViewCell(style: .Default, reuseIdentifier: "cell")
        
        tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        loadTweets()
        
    }
    
//    iQon検索データ
    func loadTweets() {
        let params = ["q": "iQON", "lang": "ja", "count": "1000"]
        TwitterAPI.search(params, tweets:  {
            twttrs in
            for tweet in twttrs {
                self.tweets.append(tweet)
            }
            self.tableView.reloadData()
            }, error: {
                error in
                print(error.localizedDescription)
        })
    }

    
    // UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of Tweets.
        return tweets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // cellをTWTRTweetTableViewCellにキャストする
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TWTRTweetTableViewCell
        if tweets.count > indexPath.row {
            let tweet = tweets[indexPath.row]
            cell.tag = indexPath.row
            cell.configureWithTweet(tweet)
        }
        return cell
    }

//    UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = self.tweets[indexPath.row] as TWTRTweet!
        if tweets.count > indexPath.row {
            prototypeCell?.configureWithTweet(tweet)
        }
        
        let height = TWTRTweetTableViewCell.heightForTweet(tweet,style: .Regular, width: self.view.bounds.width, showingActions: true)
        if !height.isNaN {
            return height
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
}