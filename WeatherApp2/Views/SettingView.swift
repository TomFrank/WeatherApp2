//
//  CityList.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/15.
//  Copyright © 2019 Peking University. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination: CityListView()
                    .environmentObject(self.userData)) {
                        Text("当前城市")
                        Spacer()
                        Text("\(userData.currentCityName ?? "")")
                            .foregroundColor(.gray)
                }
                Section {
                    Toggle(isOn: $userData.weatherManager.autoUpdate.animation()) {
                        Text("自动更新")
                    }
                    if userData.weatherManager.autoUpdate {
                        Picker(selection: $userData.weatherManager.updadingFreq, label: Text("更新频率")) {
                            ForEach(WeatherManager.UpdatingFrequency.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                    }
//                    .disabled(!userData.weatherManager.autoUpdate)
                }
                Section {
                    Picker(selection: $userData.weatherManager.lang, label: Text("语言")) {
                        ForEach(WeatherManager.Languags.allCases, id: \.self) {
                            Text($0.toString())
                        }
                    }
                    Picker(selection: $userData.weatherManager.unit, label: Text("单位")) {
                        ForEach(WeatherManager.Units.allCases, id: \.self) {
                            Text($0.toString())
                        }
                    }
                }
                Section {
                    Button(Text(APIKeyManager.shared.paid ? "专业版" : "基础版")) {
                        APIKeyManager.shared.paid.toggle()
                    }
                }
                .listStyle(GroupedListStyle())
                
            }
            .navigationBarTitle(Text("设置"), displayMode: .inline)
        }
    }
}

struct CityList_Previews: PreviewProvider {
    static var previews: some View {
        SettingView().environmentObject(UserData())
    }
}
