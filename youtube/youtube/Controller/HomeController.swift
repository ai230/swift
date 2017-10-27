//
//  ViewController.swift
//  youtube
//
//  Created by AiYamamoto on 2017-10-23.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

//    var videos: [Video] = {
//
//        var youtubeChannel = Channel()
//        youtubeChannel.name = "ThisIsTheBestChan----nel------"
//        youtubeChannel.profileImageName = "youtube_profile"
//
//        var blankSpaceVideo = Video()
//        blankSpaceVideo.thumbnailImageName = "thumbnail"
//        blankSpaceVideo.title = "Taylor Swift - Blank Space"
//        blankSpaceVideo.channel = youtubeChannel
//        blankSpaceVideo.numberOfViews = 23967545
//
//        var badbloodVideo = Video()
//        badbloodVideo.thumbnailImageName = "thumbnail2"
//        badbloodVideo.title = "Taylor Swift - badblood featuring Kendrick Lamar"
//        badbloodVideo.channel = youtubeChannel
//        badbloodVideo.numberOfViews = 6783368
//        return [blankSpaceVideo, badbloodVideo]
//    }()

    var videos: [Video]?
    
    func fetchVideos() {
    
        let url = URL(string: "http://localhost/home.json")
        
        URLSession.shared.dataTask(with: url!) {
                (data, response, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                self.videos = [Video]()
                for dictionary in json as! [[String: AnyObject]] {
                    
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    
                    let channelDictionary = dictionary["channel"] as? [String: AnyObject]
                    let channel = Channel()
                    channel.name = channelDictionary!["name"] as? String
                    channel.profileImageName = channelDictionary!["profile_image_name"] as? String
                    
                    video.channel = channel
                    
                    self.videos?.append(video)
                }
                //get back on to a main UI thread and update UI(image)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
/* print josn string from restAPI*/
//            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print(str)
            
            }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideos()
        
        //setup NaviBar - 2
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = true
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(VideoCell.self,
                                      forCellWithReuseIdentifier: "cellId")
        //create top 50px space
        collectionView?.contentInset = UIEdgeInsetsMake(100, 0, 0, 0)
        //make scrollbar does not go under the menubar
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        setupMenuBar()
        setupNavBarButtons()
    }

    func setupNavBarButtons() {
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let moreImage = UIImage(named: "more")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))

        navigationItem.rightBarButtonItems = [moreButtonItem, searchBarButtonItem]
    }

    let settingsLauncher = SettingsLauncher()
    
    @objc func handleMore() {
        //show menu
        settingsLauncher.showSettings()
    }
    
    @objc func handleSearch() {
        print("clicked search")
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    func setupMenuBar() {
        view.addSubview(menuBar)
        view.backgroundColor = UIColor.blue
        view.addConstaintsWithFormat(format: "H:|[v0]|", views: menuBar)
        //here is a difference!
        view.addConstaintsWithFormat(format: "V:|-50-[v0(60)]", views: menuBar)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
        /* it is the same code below
                if let count = videos?.count {
                    return count
                }else{
                    return 0
                }
         */
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        
        cell.video = videos?[indexPath.item]
        
        return cell
    }
    
    //add UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = (width - 16 - 16) * 9 / 16
        return CGSize(width: width, height: height + 16 + 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

