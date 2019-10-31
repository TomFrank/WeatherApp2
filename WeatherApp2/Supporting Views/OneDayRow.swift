//
//  OneDayRow.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/13.
//  Copyright © 2019 Peking University. All rights reserved.
//

import SwiftUI

struct OneDayRow: View {
    var aDay: DailyForecast
    
    var body: some View {
        //        GeometryReader { geometry in
        ZStack {
            HStack {
                Text(self.aDay.date.toString(with: "E, MMM d"))
                // .position(x: 0, y: 0)
                // .frame(alignment: .leading)
                Spacer()
            }
            HStack {
                Image(self.aDay.conditionCodeDay)
                    .resizable()
                    // .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    // .position(x: 0, y: 0)
                    .frame(width: 35, height: 35, alignment: .center)
            }
            HStack {
                Spacer()
                Text("\(self.aDay.temperatureMin)℃ / \(self.aDay.temperatureMax)℃")
                    .frame(alignment: .trailing)
            }
            
        }
//        .padding()
        //        }
    }
}

struct OneDayRow_Previews: PreviewProvider {
    static var previews: some View {
        OneDayRow(aDay: UserData().weatherManager.weatherApi.weather.dailyForecast[0])
            .previewLayout(.sizeThatFits)
    }
}
