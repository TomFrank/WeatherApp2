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
    
    private var findex: CGFloat {
        CGFloat(Float(index) ?? 0)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
//                    .trim(from: 0, to: 1)
                    .stroke(Color.gray, lineWidth: 10)
                    .opacity(0.2)
                    .frame(width: geo.size.width, height: geo.size.width)
//                    .position(x: geo.size.width/2, y: geo.size.height/2)
                Circle()
                    .trim(from: 0.1, to: self.animate ? 0.1 + 0.8 * self.findex / 500 : 0.1)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .frame(width: geo.size.width, height: geo.size.width)
//                    .position(x: geo.size.width/2, y: geo.size.height/2)
                    .rotationEffect(.degrees(90), anchor: .center)
                    .animation(Animation.linear(duration: 1))
                    .onAppear {
                        self.animate.toggle()
                    }
                    .onDisappear {
                        self.animate.toggle()
                    }
                VStack {
                    Text(self.name).padding()
                    Text("\(self.index)").fontWeight(.bold)
                }
            }
        }
    }
}

struct RingGraph_Previews: PreviewProvider {
    static var previews: some View {
        RingGraph(index: "500", name: "AQI")
            .previewLayout(.sizeThatFits)
    }
}
