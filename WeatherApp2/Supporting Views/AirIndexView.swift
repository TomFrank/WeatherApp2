//
//  AirIndexView.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/15.
//  Copyright © 2019 Peking University. All rights reserved.
//

import SwiftUI

struct AirIndexView: View {
    var air: Air
    var body: some View {
        VStack(alignment: .leading) {
            Text("空气指数")
            HStack {
                RingGraph(index: air.airNowCity.aqi, name: "AQI")
                    .frame(width: 150, height: 150)
                Spacer()
                HStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("PM10")
                        Text("PM2.5")
                        Text("NO2")
                        Text("SO2")
                        Text("O3")
                        Text("CO")
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(air.airNowCity.pm10)")
                        Text("\(air.airNowCity.pm25)")
                        Text("\(air.airNowCity.no2)")
                        Text("\(air.airNowCity.so2)")
                        Text("\(air.airNowCity.o3)")
                        Text("\(air.airNowCity.co)")
                    }
                }.padding()
            }.padding([.leading, .trailing])
        }.padding()
    }
}

struct AirIndexView_Previews: PreviewProvider {
    static var previews: some View {
        AirIndexView(air: UserData().weatherManager.airApi.air)
            .previewLayout(.sizeThatFits)
    }
}
