//
//  TweetDetailsViewController.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/30/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

	@IBOutlet weak var favoritesCountLabel: UILabel!
	@IBOutlet weak var retweetCountLabel: UILabel!
	@IBOutlet weak var timestampLabel: UILabel!
	@IBOutlet weak var tweetTextLabel: UILabel!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var profileImage: UIImageView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setTweetDetail(for tweet: Tweet) {
		if let profileUrl = tweet.user?.profileImageUrl {
			print("profile image: \(profileUrl.absoluteString)")
			profileImage.setImageWith(profileUrl)
		}
		nameLabel.text = tweet.text as String?
		usernameLabel.text = tweet.user?.screenName! as String?
		tweetTextLabel.text = tweet.text! as String
		timestampLabel.text = tweet.timestampString! as String
		retweetCountLabel.text = String("\(tweet.retweetCount ?? 0)")
		favoritesCountLabel.text = String("\(tweet.favoriteCount ?? 0)")
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
