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
	var isMoreDataLoading = false


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
		
		self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.7569, blue: 0.8588, alpha: 1.0)
		
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
	
	func loadTweets() {
		TwitterClient.sharedInstance?.homeTimeline(since: nil, success: { (tweets: [Tweet]) in
			self.tweets = tweets
			for tweet in self.tweets {
				tweet.printTweet()
			}
			self.tweetsTable.reloadData()
		}, failure: { (error: NSError) in
			print("error: \(error.localizedDescription)")
		})
	}
	
	func addTweetToTweetsTable(tweet:Tweet) {
		self.tweets.insert(tweet, at: 0)
		tweetsTable.reloadData()
	}
	
	func incrementallyLoadTweets() {
		TwitterClient.sharedInstance?.homeTimeline(since: tweets[0].id, success: { (tweets: [Tweet]) in
			let currentSize = self.tweets.count
			self.tweets = self.tweets + tweets
			for tweet in self.tweets {
				tweet.printTweet()
			}
			self.tweetsTable.reloadData()
			let indexPath = IndexPath(row: currentSize, section: 0)
			self.tweetsTable.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
		}, failure: { (error: NSError) in
			print("error: \(error.localizedDescription)")
		})
		// Update flag
		isMoreDataLoading = false
	}
	
	@IBAction func onCompose(_ sender: Any) {
		print("in on compose")
		performSegue(withIdentifier: "NewTweetViewController", sender: nil)
	}
	
	// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		let segueId = segue.identifier
		let navigationController = segue.destination as! UINavigationController
		if (segueId == "NewTweetSegue") {
			let newTweetViewController = navigationController.topViewController as! NewTweetViewController
			newTweetViewController.customInit(delegate: self)
		} else {
			let destinationViewController = navigationController.topViewController as! TweetDetailsViewController
			let cell = sender as! TweetCell
			let indexPath = tweetsTable.indexPath(for: cell)
			destinationViewController.tweet = tweets[(indexPath?.row)!]
			destinationViewController.delegate = self
		}
    }
}

extension TweetsViewController: NewTweetViewControllerDelegate {
	func newTweetViewController(newTweetViewController: NewTweetViewController, didUpdateStatus value: Bool, tweet: Tweet) {
		print("In New Tweet Delegate")
		if value == true {
			print("Updating Tweets")
			self.addTweetToTweetsTable(tweet: tweet) // this does not call the network request, but directly add to the tweets array
//			self.loadTweets()
		} else {
			print("Unable to Update Tweet")
		}
	}
}

extension TweetsViewController: TweetDetailsViewControllerDelegate {
	func tweetDetailsViewController(tweetDetailsViewController: TweetDetailsViewController, didUpdateStatus value: Bool) {
		print("In Tweet Detail Delegate")
		if value == true {
			print("Updating Tweets")
			self.loadTweets()
		} else {
			print("Unable to Update Tweet")
		}
	}
}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tweetsTable.deselectRow(at: indexPath, animated: true)
	}
}

extension TweetsViewController : UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// Calculate the position of one screen length before the bottom of the results
		let scrollViewContentHeight = tweetsTable.contentSize.height
		let tableViewBounds = tweetsTable.bounds.size.height
		let scrollOffsetThreshold = scrollViewContentHeight - tableViewBounds
		
		// When the user has scrolled past the threshold, start requesting
		let currentOffset = scrollView.contentOffset.y
		if(currentOffset > scrollOffsetThreshold && tweetsTable.isDragging) {
			isMoreDataLoading = true
			
			// Code to load more results
			incrementallyLoadTweets()
		}
	}
}
