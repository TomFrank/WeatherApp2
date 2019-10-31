//
//  RingGraph.swift
//  WeatherApp2
//
//  Created by ZZJ on 2019/10/13.
//  Copyright © 2019 Peking University. All rights reserved.
//

import SwiftUI

struct RingGraph: View {
    var index: String
    let name: String
    
    @State var animate = false
    
    var findex: CGFloat {
        CGFloat(Float(index) ?? 0)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray, lineWidth: 10)
                .opacity(0.2)
            Circle()
                .trim(from: 0.1, to: animate ? 0.1 + 0.8 * findex / 500 : 0.1)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(90))
                .animation(Animation.linear(duration: 1.5))
                .onAppear {
                    self.animate.toggle()
                }
                .onDisappear {
                    self.animate.toggle()
                }
                
            VStack {
                Text(name)
                    .padding()
                Text("\(index)").fontWeight(.bold)
            }
        }
    }
}

struct RingGraph_Previews: PreviewProvider {
    static var previews: some View {
        RingGraph(index: UserData().weatherManager.airApi.air.airNowCity.aqi, name: "AQI")
            .previewLayout(.sizeThatFits)
    }
}
