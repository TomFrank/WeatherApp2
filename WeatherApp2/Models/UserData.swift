//
//  Main.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/13.
//  Copyright © 2019 Peking University. All rights reserved.
//

import Foundation
import Combine

final class UserData: ObservableObject {
    @Published var weatherManager = WeatherManager()
    
    @Published var currentCityID: String! = "CN101010100" {
        willSet {
            weatherManager.update(of: newValue)
        }
    }
    
    var currentCityName: String? {
        weatherManager.city.availableCityList.first(where: {$0.cityID == currentCityID})?.location
    }
    
    init() {
        weatherManager.enableLocationServices()
//        weatherManager.timer.fire()
    }
}
