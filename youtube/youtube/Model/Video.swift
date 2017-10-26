//
//  Video.swift
//  youtube
//
//  Created by AiYamamoto on 2017-10-25.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

import UIKit

class Video: NSObject {
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    var channel: Channel?
}

class Channel: NSObject {
    var name: String?
    var profileImageName: String?
}
