//
//  TimelineViewController.swift
//  DotsSwiftTwitterClient
//
//  Created by AiYamamoto on 2017-03-24.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //set (self = TimelineViewController)
        tableView.delegate = self
        tableView.dataSource = self
        
        LoginCommunicator().login() { isSuccess in
            switch isSuccess {
            case false:
                print("Login Faild")
            case true:
                print("Login Success")
                
                //call TwitterCommunicator.swift
                TwitterCommunicator().getTimeline() { [weak self] data, error in
        
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    print(data)
                    //TimelineParser
                    let timelineParser = TimelineParser()
                    let tweets = timelineParser.parse(data: data!)
                    
                    print(tweets)
                    
                    self?.tweets = tweets
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension TimelineViewController:UITableViewDelegate {
    //when the cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("pressed！")
    }
    
    // cell estimatedhight
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    // cell hight
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension TimelineViewController: UITableViewDataSource {
    // the number of cell are created
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // set the number of tweets Array
        return tweets.count
    }
    
    //for TweetTableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get "TweetTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell") as! TweetTableViewCell
        
        // call fill and taks tweet
        cell.fill(tweet: tweets[indexPath.row])
        
        return cell
    }
}



