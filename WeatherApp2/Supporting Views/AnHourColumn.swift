//
//  AnHourColumn.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/13.
//  Copyright © 2019 Peking University. All rights reserved.
//

import SwiftUI

struct AnHourColumn: View {
    var anHour: Hourly
    
    var body: some View {
        VStack {
            if anHour.time.toString(with: "dhh") == Date().toString(with: "dhh") {
                Text("Now")
            } else {
                Text("\(anHour.time.toString(with: "H:mm"))")
            }
            Image(anHour.condCode).resizable().frame(width: 35, height: 35, alignment: .center)
            Text("\(anHour.temperature)℃")
        }
    }
}

struct AnHourColumn_Previews: PreviewProvider {
    static var previews: some View {
        AnHourColumn(anHour: UserData().weatherManager.weatherApi.weather.hourly[0])
            .previewLayout(.sizeThatFits)
    }
}
