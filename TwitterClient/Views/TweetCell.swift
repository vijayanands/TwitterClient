//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/29/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit
import AFNetworking
import NSDateMinimalTimeAgo

class TweetCell: UITableViewCell {
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var starImage: UIImageView!
	@IBOutlet weak var retweetImage2: UIImageView!
	@IBOutlet weak var replyImage: UIImageView!
	@IBOutlet weak var retweetImage1: UIImageView!
	@IBOutlet weak var retweetInfoLabel: UILabel!
	@IBOutlet weak var tweetTextLabel: UILabel!
	@IBOutlet weak var timestampLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var usernameLabel: UILabel!
	
	func customInit(tweet: Tweet) {
		nameLabel.text = tweet.user?.name as String?
		usernameLabel.text = tweet.user?.screenName as String?
		Utilities.setImage(forImage: profileImage, using: (tweet.user?.profileImageUrl!)!)
		tweetTextLabel.text = tweet.text as String?
		starImage.image = UIImage(named: "star.png")
		retweetImage1.image = UIImage(named: "retweet.png")
		retweetImage2.image = UIImage(named: "retweet.png")
		replyImage.image = UIImage(named: "reply.png")
		if let retweet_count = tweet.retweetCount {
			if retweet_count > 0 {
				retweetImage1.isHidden = false
				retweetInfoLabel.isHidden = false
			} else {
				retweetImage1.isHidden = true
				retweetInfoLabel.isHidden = true
			}
		} else {
			retweetImage1.isHidden = true
			retweetInfoLabel.isHidden = true
		}
		// set timestamp of tweet
		timestampLabel.text = tweet.createdAt?.timeAgo()
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
