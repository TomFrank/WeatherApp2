//
//  APIKeyManager.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/20.
//  Copyright © 2019 Peking University. All rights reserved.
//

import Foundation

class APIKeyManager {
    var paid: Bool = true
    
    private init() {}
    
    static var shared = APIKeyManager()
    
    private static let infoDictionary: [String: Any] = {
      guard let dict = Bundle.main.infoDictionary else {
        fatalError("Plist file not found")
      }
      return dict
    }()
    
    private var apiKeyName: String {
        paid ? "PAID_API_KEY" : "FREE_API_KEY"
    }
    
    private var weatherUrlName: String {
        paid ? "PAID_W_API_URL" : "FREE_W_API_URL"
    }
    
    private var airUrlName: String {
        paid ? "PAID_A_API_URL" : "FREE_A_API_URL"
    }
    
    var key: String {
        guard let key = APIKeyManager.infoDictionary[apiKeyName] as? String else {
            fatalError("API Key not set in plist for this environment")
        }
        return key
    }
    
    var weatherUrl: String {
        guard let url = APIKeyManager.infoDictionary[weatherUrlName] as? String else {
            fatalError("Weather API URL not set in plist for this environment")
        }
        return url
    }
    
    var airUrl: String {
        guard let url = APIKeyManager.infoDictionary[airUrlName] as? String else {
            fatalError("Air API URL not set in plist for this environment")
        }
        return url
    }
    
    static func getSignature(params: [String:String]) -> String {
        // TODO: getSignature
        return ""
    }
}
