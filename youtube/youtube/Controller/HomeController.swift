//
//  ViewController.swift
//  youtube
//
//  Created by AiYamamoto on 2017-10-23.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var videos: [Video]?
    
    func fetchVideos() {
        ApiService.sharedInstance.fetchVideos { (videos: [Video]) in
            self.videos = videos
            self.collectionView?.reloadData()
        }
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

    /* lazy ver - call once when 'settingsLauncher' is nil*/
    //let settingsLauncher = SettingsLauncher()
    //change to below bcz launcher.homeController need to be 'self'
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    @objc func handleMore() {
        //show menu
        settingsLauncher.showSettings()
    }
    
    //is called from SettingsLauncher class
    func showControllerForSetting(setting: Setting) {
        let dummySettingViewController = UIViewController()
        dummySettingViewController.view.backgroundColor = UIColor.white
        dummySettingViewController.navigationItem.title = setting.name
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.pushViewController(dummySettingViewController, animated: true)
    }
    
    @objc func handleSearch() {
        print("clicked search")
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)

        view.addSubview(redView)
        view.addConstaintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstaintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.backgroundColor = UIColor.blue
        view.addConstaintsWithFormat(format: "H:|[v0]|", views: menuBar)
        //here is a difference!
        view.addConstaintsWithFormat(format: "V:|-50-[v0(60)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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

