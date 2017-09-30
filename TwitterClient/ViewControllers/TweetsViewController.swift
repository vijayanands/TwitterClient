//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/29/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
	
	var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
			self.tweets = tweets
			
			for tweet in tweets {
				tweet.printTweet()
			}
		}, failure: { (error: NSError) in
			print("error: \(error.localizedDescription)")
		})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func onLogout(_ sender: Any) {
		TwitterClient.sharedInstance?.logout()
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
