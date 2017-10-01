//
//  NewTweetViewController.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/30/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
	@objc optional func newTweetViewController(newTweetViewController: NewTweetViewController,
	                                          didUpdateStatus value: Bool)
}

class NewTweetViewController: UIViewController {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var screenNameLabel: UILabel!
	@IBOutlet weak var tweetTextView: UITextView!
	@IBOutlet weak var profileImage: UIImageView!
	
	var replyMode = false
	var replyTo: Int? = nil
	weak var delegate: NewTweetViewControllerDelegate?
	
	override func viewDidLoad() {
        super.viewDidLoad()

		let user = User.currentUser
		nameLabel.text = user?.name as String?
		screenNameLabel.text = user?.screenName as String?
		Utilities.setImage(forImage: profileImage, using: (user?.profileImageUrl)!)
		
		self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.7569, blue: 0.8588, alpha: 1.0)
		
        // Do any additional setup after loading the view.
		tweetTextView.becomeFirstResponder()
		tweetTextView!.layer.borderWidth = 1
		tweetTextView!.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func customInit(delegate: NewTweetViewControllerDelegate) {
		self.delegate = delegate
	}
	
	@IBAction func onCancel(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onTweet(_ sender: Any) {
		print("\(tweetTextView.text)")
		TwitterClient.sharedInstance?.submitTweet(status: tweetTextView.text, inReply: replyMode, replyTo: replyTo, success: {
			print("success posting tweet")
			self.delegate?.newTweetViewController!(newTweetViewController: self, didUpdateStatus: true)
		}, failure: { (error: Error) in
			print("error posting: \(error.localizedDescription)")
			self.delegate?.newTweetViewController!(newTweetViewController: self, didUpdateStatus: false)
		})
		dismiss(animated: true, completion: nil)
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
