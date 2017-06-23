//
//  ViewController.swift
//  SimpleBrowserApp
//
//  Created by AiYamamoto on 2017-06-22.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var addressBar: UITextField!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var infoLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapGo(_ sender: Any) {
        if addressBar.text == ""{
            return
        }
        guard let text:String = addressBar.text else {
            return
        }
        infoLbl.isHidden = true
        if addressBar.text == "" {
            let finalStr = "https://www.google.com"
            loadURL(str: finalStr)
        }
        if text.range(of: ".") != nil {
            var finalStr:String = text.lowercased()
            if finalStr.range(of: "http://") == nil {
                finalStr = "http://\(finalStr)"
            }
            loadURL(str: finalStr)
        } else {
            let serchStr = text.replacingOccurrences(of: "", with: "+")
            let finalStr = "https://www.google.com/search?q=\(serchStr)"
            loadURL(str: finalStr)
        }
        
        
    }
    func loadURL(str:String) {
        let url = NSURL(string: str as String)
        
        let request = NSURLRequest(url: url! as URL)
        
        webView.loadRequest(request as URLRequest)
        
    }


    @IBAction func goBack(_ sender: Any) {
        webView.goBack()
    }

    @IBAction func goForward(_ sender: Any) {
        webView.goForward()
    }
}

