//
//  HourlyForecastScroll.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/14.
//  Copyright © 2019 Peking University. All rights reserved.
//

import SwiftUI
import CoreData

struct HourlyForecastScroll: View {
    var weather: Weather
//    @FetchRequest(
//        entity: HourlyData.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \HourlyData.time, ascending: true)]
//    ) var hourlyData: FetchedResults<HourlyData>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(weather.hourly) { anHour in
                    if self.weather.update.localTime.timeIntervalSinceNow < -24 * 60 * 60 || anHour.time >= Date() - 60 * 60 {
                        AnHourColumn(anHour: anHour)
                    }
                }
            }
            .padding()
        }
    }
}

struct HourlyForecastScroll_Previews: PreviewProvider {
    static var previews: some View {
//        HourlyForecastScroll()
        HourlyForecastScroll(weather: UserData().weatherManager.weatherApi.weather)
            .previewLayout(.sizeThatFits)
    }
}
