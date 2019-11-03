//
//  MainWeatherView.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/15.
//  Copyright © 2019 Peking University. All rights reserved.
//

import SwiftUI

struct MainWeatherView: View {
    var weather: Weather
    
    var body: some View {
        VStack(alignment: .center,spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("\(weather.now.temperature)")
                    .font(.custom("", size:80))
//                Text("℃")
            }
            Text("\(weather.dailyForecast[0].temperatureMin)℃ / \(weather.dailyForecast[0].temperatureMax)℃")
                .font(.body)
            Text(weather.now.condText)
                .font(.body)
            Text("\(weather.basic.location)")
                .font(.body)
            HStack {
                Text("数据: heweather.com").font(.footnote)
                Spacer()
                Text("更新于 \(Date().timeIntervalSince(weather.update.localTime) < 24 * 60 * 60 ? weather.update.localTime.toString(with: "h:mm") : weather.update.localTime.toString(with: "M-d"))").font(.footnote)
            }
            .padding([.leading, .trailing])
        }
    }
}

struct MainWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        MainWeatherView(weather: UserData().weatherManager.weatherApi.weather)
            .previewLayout(.sizeThatFits)
    }
}
