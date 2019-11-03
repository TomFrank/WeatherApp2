//
//  Home.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/13.
//  Copyright © 2019 Peking University. All rights reserved.
//

import SwiftUI
import CoreData

struct Home: View {
    @EnvironmentObject private var userData: UserData
    @State var showingSettings: Bool = false
    
    var weather: Weather {
        userData.weatherManager.weatherApi.weather
    }
    
    var air: Air {
        userData.weatherManager.airApi.air
    }
    
    var settingButton: some View {
        Button(action: { self.showingSettings.toggle() }) {
            Image(systemName: "ellipsis")
                .imageScale(.large)
                .padding()
        }
    }
    
    var body: some View {
        ZStack { //
            Image("b100")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            BlurView(style: .regular)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    settingButton
                }.frame(height: 30).padding([.trailing])
//                RefreshableScrollView(refreshing: $userData.weatherManager.loading) {
                ScrollView {
                    MainWeatherView(weather: self.weather)
                    Divider()
                    HourlyForecastScroll(weather: self.weather)
                    Divider()
                    DailyForecastList(dailyForecast: self.weather.dailyForecast)
                    Divider()
                    AirIndexView(air: self.air)
                }
            }
            .padding([.leading, .trailing])
        }
        .sheet(isPresented: self.$showingSettings) {
            SettingView()
                .environmentObject(self.userData)}
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
            .environmentObject(UserData())
    }
}
