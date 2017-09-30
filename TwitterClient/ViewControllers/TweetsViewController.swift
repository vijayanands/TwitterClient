//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/29/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
	
	@IBOutlet weak var tweetsTable: UITableView!
	var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
		tweetsTable.delegate = self
		tweetsTable.dataSource = self
		tweetsTable.estimatedRowHeight = 130
		tweetsTable.rowHeight = UITableViewAutomaticDimension
		
		// Initialize a UIRefreshControl
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
		// add refresh control to table view
		tweetsTable.insertSubview(refreshControl, at: 0)
		
		self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.8588, blue: 0.8157, alpha: 1.0)
		
        // Do any additional setup after loading the view.
		loadTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func onLogout(_ sender: Any) {
		TwitterClient.sharedInstance?.logout()
	}
	
	// Makes a network request to get updated data
	// Updates the tableView with the new data
	// Hides the RefreshControl
	@objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
		// ... Create the URLRequest `myRequest` ...
		loadTweets()
		// Tell the refreshControl to stop spinning
		refreshControl.endRefreshing()
	}
	
	fileprivate func loadTweets() {
		TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
			self.tweets = tweets
			for tweet in self.tweets {
				tweet.printTweet()
			}
			self.tweetsTable.reloadData()
		}, failure: { (error: NSError) in
			print("error: \(error.localizedDescription)")
		})
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		let destinationViewController = segue.destination as! TweetDetailsViewController
		let cell = sender as! TweetCell
		let indexPath = tweetsTable.indexPath(for: cell)
		destinationViewController.setTweetDetail(for: tweets[(indexPath?.row)!])
    }
}

extension TweetsViewController: UITableViewDelegate {
	
}

extension TweetsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tweets != nil {
			return tweets.count
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tweetsTable.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
		cell.customInit(tweet: tweets[indexPath.row])
		return cell
	}
}
