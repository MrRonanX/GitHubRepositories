//
//  LoadingView.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import SwiftUI

struct LoadingView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isAnimating = false
 
    private let style = StrokeStyle(lineWidth: 6, lineCap: .round)

    
    var body: some View {
        ZStack {
            background
                .opacity(0.01)
                .ignoresSafeArea()
            VStack {
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        AngularGradient(gradient: .init(colors: [startColor, endColor]), center: .center),
                        style: style
                    )
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 0.7).repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            .frame(width: 100, height: 100)
        }.onAppear {
            isAnimating.toggle()
        }
    }
    
    var background: some View {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    private var startColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var endColor: Color {
        colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5)
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}

