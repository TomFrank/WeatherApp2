//
//  Weather.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/13.
//  Copyright © 2019 Peking University. All rights reserved.
//

import Foundation
import CoreLocation
import Dispatch
import Combine

class WeatherManager: NSObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager = CLLocationManager()
    
    public private(set) var weatherApi: WeatherAPI = WeatherAPI(unit: "m", lang: "zh")
    public private(set) var airApi: AirAPI = AirAPI(unit: "m", lang: "zh")
    var city = CityAPI()
    
    var loading: Bool = false {
        didSet {
            if oldValue == false && loading == true {
                // Do async stuff here
                DispatchQueue.main.async {
                    self.update()
                    // When finished loading (must be done on the main thread)
                    self.loading = false
                }
            }
        }
    }
    
//    var outdated: Bool {
//        weatherApi.weather.update.localTime.timeIntervalSinceNow > -24 * 60 * 60
//    }
    
    private lazy var lastCheckTime: Date = weatherApi.weather.update.localTime
    var autoUpdate: Bool = true
    var updadingFreq: UpdatingFrequency = .f30m
    
    var lang: Languags = .zh
    var unit: Units = .m
    
    var currentLocation: Basic?
    
    lazy var timer = Timer(timeInterval: 30 * 60, repeats: true) { timer in
        self.update()
    }
    
    enum Languags: String, CaseIterable {
        case zh
        case en
        
        func toString() -> String {
            switch self {
            case .zh:
                return "中文简体"
            case .en:
                return "English"
            }
        }
    }
    
    enum Units: String, CaseIterable {
        case m
        case i
        
        func toString() -> String {
            switch self {
            case .m:
                return "公制"
            case .i:
                return "英制"
            }
        }
    }
    
    enum UpdatingFrequency: String, CaseIterable {
        case f30m = "30 分钟"
        case f1h = "1 小时"
        case f3h = "3 小时"
        case f1d = "1 天"
    }
    
    func update() {
        if lastCheckTime.timeIntervalSinceNow > -60 {
            print("Weather already up-to-date")
        } else {
//            print("Weather updated")
            lastCheckTime = Date()
            self.weatherApi.updateWeather()
            self.airApi.updateAir()
        }
    }
    
    func update(of cityID: String) {
        self.weatherApi.updateCity(of: cityID)
        self.airApi.updateCity(of: cityID)
    }
    
    func enableLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = kCLLocationAccuracyThreeKilometers
        if !CLLocationManager.locationServicesEnabled() {
            print("location services not enabled")
            return
        }
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            print("significant Location Change services not available")
            return
        }
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // Request when-in-use authorization initially
            manager.requestAlwaysAuthorization()
        case .restricted, .denied:
            manager.stopUpdatingLocation()
            print("Restricted or Denied Authorization")
        case .authorizedWhenInUse:
            // Enable basic location features
            print("When-In-Use Authorization success")
        case .authorizedAlways:
            // Enable any of your app's location features
            manager.startUpdatingLocation()
            print("Always Authorization success")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        print(lastLocation.coordinate.toString())
        city.search(for: lastLocation.coordinate) { searchCity in
            self.currentLocation = searchCity
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            print("\(error)")
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(Data, URLResponse), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { data, response, error in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                result(.failure(error!))
                return
            }
            if let data = data {
                result(.success((data, httpResponse)))
            }
        }
    }
}

extension FileManager {
    static var documentDirectory : URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

extension String {
    func toDate(with format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func toString(with format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension CLLocationCoordinate2D {
    // 经度,纬度（经度在前纬度在后，英文,分隔，十进制格式，北纬东经为正，南纬西经为负
    func toString() -> String {
        return "\(self.longitude),\(self.latitude)"
    }
}

extension JSONDecoder.DateDecodingStrategy {
    static func getCustomStrategy() -> JSONDecoder.DateDecodingStrategy {
        let dateFormatter = DateFormatter()
        return .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            // dateFormatterWithoutTime
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            // dateFormatterWithTime
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            //
            dateFormatter.dateFormat = "HH:mm"
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        }
    }
}


