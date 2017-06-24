//
//  Time.swift
//  barcampevn
//

import SwiftyJSON

struct Time {
    
    var date: String!
    var timezone: String!
    var timezone_type: String!

    init(data: JSON) {
        self.date           = data["date"].stringValue
        self.timezone       = data["timezone"].stringValue
        self.timezone_type  = data["timezone_type"].stringValue
    }
}
