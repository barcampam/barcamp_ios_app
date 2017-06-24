//
//  APIManager.swift
//  barcampevn
//

import SwiftyJSON
import Alamofire

typealias CompletionBlock = (_ result: JSON?, _ error: Error?) -> Void

let apiManager = APIManager.shared

class APIManager {
    
    static let shared = APIManager()
    
    //MARK: - API Routers -
    private enum Routers
    {
        static let baseURL  = "http://api.barcamp.am/"
        static let schedule = "schedule"
    }
    
    //MARK: - Request -
    private func request(method: HTTPMethod,
                         url: String,
                         parameters: [String: Any]? = nil,
                         showProgress: Bool = true,
                         completionBlock: @escaping CompletionBlock)
    {
            if showProgress { UIHelper.showProgressHUD() }
            
        let URL = Routers.baseURL + url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(URL, method: method,
                          parameters: parameters,
                          encoding: URLEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    completionBlock(JSON(data), nil)
                case .failure(let error):
                    UIHelper.showHUD(error.localizedDescription)
                    completionBlock(nil, error)
                }
                
                if showProgress { UIHelper.hideProgressHUD() }
        }
    }
    
    //MARK: - Public Methods -
    func getSchedule(completionBlock: @escaping CompletionBlock) {
        request(method: .get, url: Routers.schedule, completionBlock: completionBlock)
    }
}
