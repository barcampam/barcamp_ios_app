//
//  UISettings.swift
//  barcampevn
//

import UIKit

//MARK: - ScreenSize -
enum Screen
{
    static let width                    = UIScreen.main.bounds.size.width
    static let height                   = UIScreen.main.bounds.size.height
    static let max_length               = max(Screen.width, Screen.width)
    static let min_length               = min(Screen.height, Screen.height)
}

//MARK: - DeviceType -
enum Device
{
    static let iphone                   = UIDevice.current.userInterfaceIdiom == .phone && Screen.max_length < 568.0
    static let iphone_5                 = UIDevice.current.userInterfaceIdiom == .phone && Screen.max_length == 568.0
    static let iphone_6                 = UIDevice.current.userInterfaceIdiom == .phone && Screen.max_length == 667.0
    static let iphone_6p                = UIDevice.current.userInterfaceIdiom == .phone && Screen.max_length == 736.0
    static let ipad                     = UIDevice.current.userInterfaceIdiom == .pad && Screen.max_length == 1024.0
}

//MARK: - Colors -
enum Color
{
    static let gray_246                 = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    static let gray_142                 = UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1)
    static let gray_42                  = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1)
    static let blue                     = UIColor(red: 30/255, green: 25/255, blue: 81/255, alpha: 1)  
}

//MARK: - Fonts -
enum Font
{
    static let system_13                = UIFont.systemFont(ofSize: 13)
    static let system_14                = UIFont.systemFont(ofSize: 14)
    static let boldSystem_13            = UIFont.boldSystemFont(ofSize: 13)
    static let boldSystem_14            = UIFont.boldSystemFont(ofSize: 14)
    static let boldSystem_17            = UIFont.boldSystemFont(ofSize: 17)
}


