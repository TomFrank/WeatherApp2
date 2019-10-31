//
//  DailyForecastList.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/14.
//  Copyright © 2019 Peking University. All rights reserved.
//

import SwiftUI

struct DailyForecastList: View {
    var dailyForecast: [DailyForecast]
    var body: some View {
        VStack {
            ForEach(dailyForecast) { aDay in
                OneDayRow(aDay: aDay)
            }
        }
        .padding([.leading, .trailing])
    }
}

struct DailyForecastList_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastList(dailyForecast: UserData().weatherManager.weatherApi.weather.dailyForecast)
            .previewLayout(.sizeThatFits)
    }
}
