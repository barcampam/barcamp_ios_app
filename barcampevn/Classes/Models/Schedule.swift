//
//  Schedule.swift
//  barcampevn
//

import SwiftyJSON

struct Schedule {
    
    var room: String!
    var time_to: Time
    var time_from: Time
    var en: Speaker
    var hy: Speaker
    var bg_image_url: String!
    var timeForShowInHeader: String!

    init(data: JSON) {
        self.room           = data["room"].stringValue
        self.time_to        = Time(data: data["time_to"])
        self.time_from      = Time(data: data["time_from"])
        self.en             = Speaker(data: data["en"])
        self.hy             = Speaker(data: data["hy"])
        self.bg_image_url   = data["bg_image_url"].stringValue
    }
}
