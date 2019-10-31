//
//  CityAPI.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/15.
//  Copyright © 2019 Peking University. All rights reserved.
//

import Foundation
import CoreLocation

class CityAPI {
    private var city: City!
    private let citySearchURL = "https://search.heweather.net/find/"
    private let session = URLSession.shared
    
    private let key: String
    let lang: String
    
    var availableCityList: [Basic] {
        city.basic
    }
    
    private struct WeatherJSONRoot: Codable {
        let root: [City]
        enum CodingKeys: String, CodingKey {
            case root = "HeWeather6"
        }
    }
    
    init(lang: String = "zh") {
        self.key = APIKeyManager.shared.key
        self.lang = lang
        city = loadTestData(filename: "cityData.json", as: WeatherJSONRoot.self).root[0]
    }
    
    func search(for coordinate: CLLocationCoordinate2D, completion: @escaping (Basic?) -> Void) {
        search(for: coordinate.toString(), completion: completion)
    }
    
    func search(for location: String, completion: @escaping (Basic?) -> Void) {
        guard var citySearchURL = URLComponents(string: citySearchURL) else {
            fatalError("error: bad weatherAPIURL")
        }
        citySearchURL.queryItems = [
            URLQueryItem(name: "location", value: location),
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "lang", value: lang)]
        
        guard let citySearchURLWithQuery = citySearchURL.url else {
            fatalError("error: bad query")
        }
        
        session.dataTask(with: citySearchURLWithQuery) { result in
            switch result {
            case .failure:
                print("failed: get json")
                completion(nil)
            case .success(let data, _):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.getCustomStrategy()
                
                let data = try! decoder.decode(WeatherJSONRoot.self, from: data).root[0]
                
                completion(data.basic[0])
            }
        }.resume()
    }
    
}

struct City: Codable {
    var basic: [Basic]
    let status: String
}
