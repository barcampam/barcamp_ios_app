//
//  UIHelper.swift
//  barcampevn
//

import KRProgressHUD

struct UIHelper {
    
    static func showHUD(_ message: String) {
        KRProgressHUD.showMessage(message)
    }
    
    static func showProgressHUD() {
        KRProgressHUD.show()
    }
    
    static func hideProgressHUD() {
        KRProgressHUD.dismiss()
    }
}
