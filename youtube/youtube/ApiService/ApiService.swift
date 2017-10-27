//
//  ApiService.swift
//  youtube
//
//  Created by AiYamamoto on 2017-10-27.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit

class ApiService: NSObject {

    static let sharedInstance = ApiService()
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        
        let url = URL(string: "http://localhost/home.json")
        
        URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            do {
                //parse the data from JSON to an array
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                var videos = [Video]()
                
                for dictionary in json as! [[String: AnyObject]] {
                    
                    let video = Video()
                    
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    
                    let channelDictionary = dictionary["channel"] as? [String: AnyObject]
                    let channel = Channel()
                    channel.name = channelDictionary!["name"] as? String
                    channel.profileImageName = channelDictionary!["profile_image_name"] as? String
                    
                    video.channel = channel
                    
                    videos.append(video)
                }
                //get back on to a main UI thread and update UI(image)
                DispatchQueue.main.async {
                    //video 's been parsed above
                    completion(videos)
                    //self.collectionView?.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            /* print josn string from restAPI*/
            //            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //            print(str)
            
            }.resume()
        
    }
}
