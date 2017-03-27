//
//  Tweet.swift
//  DotsSwiftTwitterClient
//
//  Created by AiYamamoto on 2017-03-24.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import Foundation

struct Tweet {
    //Tweet id
    let id: String
    //Tweet text
    let text:String
    //owner of this Tweet
    let user: User
    
    //json
    init(id: String, text: String, user: User) {
        self.id = id
        self.text = text
        self.user = user
    }
    
    init?(json: Any) {
        guard let dictionary = json as? [String: Any] else { return nil }
        
        guard let id = dictionary["id_str"] as? String else { return nil }
        guard let text = dictionary["text"] as? String else { return nil }
        guard let userJSON = dictionary["user"] else { return nil }
        guard let user = User(json: userJSON) else { return nil }
        
        self.id = id
        self.text = text
        self.user = user
    }
}
