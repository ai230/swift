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
        
        tableView.delegate = self
        // dataSourceの指定を自分自身(self = TimelineViewController)に設定
        tableView.dataSource = self
        
        // create test data
        let user = User(id: "1", screenName: "ktanaka117", name: "ダンボー田中", profileImageURL: "https://pbs.twimg.com/profile_images/832034247414206464/PCKoQRPD.jpg")
        let tweet = Tweet(id: "01", text: "Twitterクライアント作成なう", user: user)
        
        let tweets = [tweet]
        self.tweets = tweets
        
        // tableViewのリロード
        tableView.reloadData()
        
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // 描画するcellを設定する関数
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TweetTableViewCellを表示したいので、TweetTableViewCellを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell") as! TweetTableViewCell
        
        return cell
    }
}



