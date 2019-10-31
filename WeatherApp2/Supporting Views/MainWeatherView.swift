//
//  MainWeatherView.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/15.
//  Copyright © 2019 Peking University. All rights reserved.
//

import SwiftUI

struct MainWeatherView: View {
    var weatherManager: WeatherManager
    
    var weather: Weather {
        weatherManager.weatherApi.weather
    }
    
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
                Text("更新于 \(weatherManager.outdated ? weather.update.localTime.toString(with: "h:mm") : weather.update.localTime.toString(with: "M-d"))").font(.footnote)
            }
            .padding([.leading, .trailing])
        }
    }
}

struct MainWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        MainWeatherView(weatherManager: UserData().weatherManager)
            .previewLayout(.sizeThatFits)
    }
}
