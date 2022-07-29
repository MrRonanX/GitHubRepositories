//
//  GeoScroll.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import SwiftUI

struct GeoScroll<Content>: View where Content : View {
    
    var content: (GeometryProxy) -> Content
    
    init(@ViewBuilder content: @escaping (GeometryProxy) -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                content(geo)
            }
            .frame(width: geo.size.width)
        }
    }
}

struct GeoScroll_Previews: PreviewProvider {
    static var previews: some View {
        GeoScroll { geo in
            Text("Hello World")
        }
    }
}
