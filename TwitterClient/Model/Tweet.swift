//
//  Tweet.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/29/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

class Tweet: NSObject {
	let text: NSString?
	let favoriteCount: Int?
	let retweetCount: Int?
	var createdAt: NSDate?
	var timestampString : NSString?
	var user: User?
	
	init(tweetDictionary: NSDictionary) {
		text = tweetDictionary["text"] as? NSString
		favoriteCount = (tweetDictionary["favorite_count"] as? Int) ?? 0
		retweetCount = (tweetDictionary["retweet_count"] as? Int) ?? 0
		timestampString = tweetDictionary["created_at"] as? NSString
		
		if let timestampString = timestampString {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
			createdAt = (dateFormatter.date(from: timestampString as String) as NSDate?) ?? nil
		}
		
		// initialize user
		let userDictionary = tweetDictionary["user"]
		user = User(userDictionary: userDictionary as! NSDictionary)
	}
	
	class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
		var tweets = [Tweet]()
	
		for dictionary in dictionaries {
			let tweet = Tweet(tweetDictionary: dictionary)
			tweets.append(tweet)
		}
		return tweets
	}
	
	func printTweet() {
		print("Text: \(text!)")
		print("Created at: \(createdAt!)")
		print("Retweet Count: \(retweetCount!)")
		print("Favorite Count: \(favoriteCount!)")
	}
}
