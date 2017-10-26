//
//  Extensions.swift
//  youtube
//
//  Created by AiYamamoto on 2017-10-25.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstaintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String = ""
    
    func loadImageUsingUrlString(urlString: String) {
        imageUrlString = urlString
        
        let imageUrl = URL(string: urlString)
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        //Request
        URLSession.shared.dataTask(with: imageUrl!, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            //get back on to a main UI thread and update UI(image)
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                
                //Check if 'imageUrlString' still equall to 'urlString'
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
        }).resume()
    }
}
/* extension ver
extension UIImageView {
    func loadImageUsingUrlString(urlString: String) {
        let imageUrl = URL(string: urlString)
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        //Request
        URLSession.shared.dataTask(with: imageUrl!, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            //get back on to a main UI thread and update UI(image)
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                self.image = imageToCache
            }
        }).resume()
    }
}*/
