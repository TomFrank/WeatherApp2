//
//  CityListView.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/15.
//  Copyright © 2019 Peking University. All rights reserved.
//

import SwiftUI

struct CityListView: View {
    @EnvironmentObject private var userData: UserData
    @State private var searchQuery: String = ""
    @State private var selectedID: String?
//    @State private var n = Set<String>()
    
    var body: some View {
        VStack(alignment: .leading) {
            SearchBar(text: $searchQuery, placehoder: "搜索")
            Text("当前定位: \(userData.weatherManager.currentLocation?.parentCity ?? "") \(userData.weatherManager.currentLocation?.location ?? "")")
            List(userData.weatherManager.city.availableCityList.filter({
                searchQuery.isEmpty ||
                    !$0.location.commonPrefix(with: searchQuery).isEmpty
            }) ) { city in
                HStack {
                    Text("\(city.location)")
                    Spacer()
                    if (self.selectedID == nil && self.userData.currentCityID == city.cityID) ||  self.selectedID == city.cityID {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .onTapGesture {
                    self.selectedID = city.cityID
                }
            }
//            .listStyle(GroupedListStyle())
        }
//        .onAppear {
//            self.selectedID = self.userData.currentCityID
//        }
        .padding([.leading, .trailing])
//        .environment(\.editMode, .constant(EditMode.active))
        .navigationBarTitle(Text("城市选择"), displayMode: .inline) //
        .onDisappear {
            if self.selectedID != nil {
                self.userData.currentCityID =  self.selectedID!
            }
        }
        
    }
}

struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CityListView().environmentObject(UserData())
        }
    }
}
