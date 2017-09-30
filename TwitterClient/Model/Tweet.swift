//
//  Tweet.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/29/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

class Tweet: NSObject {
	private let text: NSString?
	private let favoriteCount: Int?
	private let retweetCount: Int?
	private var createdAt: NSDate?
	
	init(tweetDictionary: NSDictionary) {
		text = tweetDictionary["text"] as? NSString
		favoriteCount = (tweetDictionary["favorite_count"] as? Int) ?? 0
		retweetCount = (tweetDictionary["retweet_count"] as? Int) ?? 0
		let timestampString = tweetDictionary["created_at"] as? String
		
		if let timestampString = timestampString {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
			createdAt = (dateFormatter.date(from: timestampString) as NSDate?) ?? nil
		}
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
