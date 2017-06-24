//
//  Speaker.swift
//  barcampevn
//

import SwiftyJSON

struct Speaker {
    
    var speaker: String!
    var topic: String!

    init(data: JSON) {
        self.speaker    = data["speaker"].stringValue
        self.topic      = data["topic"].stringValue
    }
}
