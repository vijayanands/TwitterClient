//
//  User.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/29/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

class User: NSObject {
	private let name: NSString?
	private let screenName: NSString?
	private let profileImageUrl: URL?
	private let tagLine: NSString?
	
	init(userDictionary:NSDictionary) {
		name = userDictionary["name"] as? NSString
		screenName = userDictionary["screen_name"] as? NSString
		tagLine = userDictionary["description"] as? NSString
		let profileImageUrlString = userDictionary["profile_image_url"] as? NSString
		if let profileImageUrlString = profileImageUrlString {
			profileImageUrl = URL(string: profileImageUrlString as String)
		} else {
			profileImageUrl = nil
		}
	}
	
	func printUser() {
		print("name: \(self.name!)")
		print("screenName: \(self.screenName!)")
		print("description \(self.tagLine!)")
		print("profileImageUrl: \(self.profileImageUrl!.absoluteString)")
	}
}
