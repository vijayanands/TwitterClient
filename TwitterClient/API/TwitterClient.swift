//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/27/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

private let twitterApiUrl = "https://api.twitter.com"
private let consumerApiKey = "elk9OGzs1ZoJWOPvf3khYPFot"
private let consumerSharedSecret = "KK4sBiglaZhkmWCn8VnhprOdCzWNbGtEh8xYj00SZhcHF4z2GC"

class TwitterClient: NSObject {
	private override init() {
	}
	
	var twitterSession: BDBOAuth1SessionManager {
		return BDBOAuth1SessionManager(baseURL: URL(string: twitterApiUrl), consumerKey: consumerApiKey, consumerSecret: consumerSharedSecret)
	}
	
	static let sharedInstance: TwitterClient = {
		let instance = TwitterClient()
		return instance
	}()
}
