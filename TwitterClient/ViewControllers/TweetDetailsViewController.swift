//
//  TweetDetailsViewController.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/30/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

@objc protocol TweetDetailsViewControllerDelegate {
	@objc optional func tweetDetailsViewController(tweetDetailsViewController: TweetDetailsViewController,
	                                           didUpdateStatus value: Bool)
}

class TweetDetailsViewController: UIViewController {

	@IBOutlet weak var tweetFunctionsControl: UISegmentedControl!
	@IBOutlet weak var favoritesCountLabel: UILabel!
	@IBOutlet weak var retweetCountLabel: UILabel!
	@IBOutlet weak var timestampLabel: UILabel!
	@IBOutlet weak var tweetTextLabel: UILabel!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var profileImage: UIImageView!
	
	weak var delegate: TweetDetailsViewControllerDelegate?
	
	var tweet: Tweet?
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setTweetDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setTweetDetail() {
		if let profileUrl = tweet?.user?.profileImageUrl {
			Utilities.setImage(forImage: profileImage, using: profileUrl)
		}
		nameLabel.text = tweet?.user?.name as String?
		usernameLabel.text = tweet?.user?.screenName! as String?
		tweetTextLabel.text = tweet?.text! as String?
		timestampLabel.text = tweet?.timestampString! as String?
		retweetCountLabel.text = String("\(tweet?.retweetCount ?? 0)")
		favoritesCountLabel.text = String("\(tweet?.favoriteCount ?? 0)")
	}

	@IBAction func homeButtonSelected(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onSelect(_ sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			// reply tweet
			performSegue(withIdentifier: "ReplyTweetSegue", sender: nil)
			tweetFunctionsControl.selectedSegmentIndex = UISegmentedControlNoSegment
		}
		if sender.selectedSegmentIndex == 1 {
			// retweet
			tweetFunctionsControl.selectedSegmentIndex = UISegmentedControlNoSegment
			TwitterClient.sharedInstance?.retweet(id: (tweet?.id)!, success: { () in
				print("Retweet Successful")
				self.delegate?.tweetDetailsViewController!(tweetDetailsViewController: self, didUpdateStatus: true)
			}, failure: { (error: NSError) in
				print("error: \(error.localizedDescription)")
			})
			dismiss(animated: true, completion: nil)
		}
		if sender.selectedSegmentIndex == 2 {
			// favorite tweet
			tweetFunctionsControl.selectedSegmentIndex = UISegmentedControlNoSegment
			TwitterClient.sharedInstance?.favoriteTweet(id: (tweet?.id)!, success: {
				self.delegate?.tweetDetailsViewController!(tweetDetailsViewController: self, didUpdateStatus: true)
			}, failure: { (error: NSError) in
				print("error: \(error.localizedDescription)")
			})
			dismiss(animated: true, completion: nil)
		}
	}
	
	// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		let navigationController = segue.destination as! UINavigationController
		let destinationViewController = navigationController.topViewController as! NewTweetViewController
		destinationViewController.customInit(delegate: self)
		destinationViewController.replyMode = true
		destinationViewController.replyTo = tweet?.id
    }

}

extension TweetDetailsViewController: NewTweetViewControllerDelegate {
	func newTweetViewController(newTweetViewController: NewTweetViewController, didUpdateStatus: Bool) {
		print("In New Tweet Delegate")
		if didUpdateStatus == true {
			print("Updating Tweets")
			self.delegate?.tweetDetailsViewController!(tweetDetailsViewController: self, didUpdateStatus: true)
			dismiss(animated: true, completion: nil)
		} else {
			print("Unable to Update Tweet")
		}
	}
}

