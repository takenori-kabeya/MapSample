//
//  ContentView.swift
//  MapSample
//
//  Created by Takenori Kabeya on 2023/05/27.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var locationName: String = "テスト"
    @State var pinCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State var pinDropped: Bool = false
    @State var selectedTab: Int = 1
 
    var body: some View {
        VStack {
            TextField("場所名", text: $locationName)
                .textFieldStyle(.roundedBorder)
            let latitude = pinDropped ? "\(pinCoordinate.latitude)" : "(未設定)"
            let longitude = pinDropped ? "\(pinCoordinate.longitude)" : "(未設定)"
            Text("緯度: \(latitude)")
            Text("経度: \(longitude)")
            TabView(selection: $selectedTab) {
                MapViewWithPinMode(pinCoordinate: $pinCoordinate, pinDropped: $pinDropped, pinName: locationName)
                    .tabItem {
                        Image(systemName: "mappin.circle")
                        Text("ピンドラッグモード版")
                    }.tag(1)
                MapViewWithCross(pinCoordinate: $pinCoordinate, pinDropped: $pinDropped, pinName: locationName)
                    .tabItem {
                        Image(systemName: "plus.viewfinder")
                        Text("十字版")
                    }.tag(2)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
