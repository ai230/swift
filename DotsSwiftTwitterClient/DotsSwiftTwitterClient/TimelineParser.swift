//
//  TimelineParser.swift
//  DotsSwiftTwitterClient
//
//  Created by AiYamamoto on 2017-03-26.
//  Copyright © 2017 Ai Yamamoto. All rights reserved.
//

//In order to serialize to data model the json data which you got
import Foundation

struct TimelineParser {
    func parse(data: Data) -> [Tweet] {
        let serializedData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        let json = serializedData as! [Any]
        let timeline: [Tweet] = json.flatMap {
            Tweet(json: $0)
        }
        return timeline
    }
}
