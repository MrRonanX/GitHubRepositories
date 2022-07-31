//
//  ContentView.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/28/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: ViewModel
    
    let environment: AppEnvironment
    
    init() {
        environment = AppEnvironment.start()
        
        let viewModel = ViewModel(container: environment.container)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.isLoggedIn {
                    TabBarView(viewModel: .init(container: viewModel.container))
                } else {
                    LoginView(viewModel: .init(container: viewModel.container))
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
            
        }
        .animation(.default, value: viewModel.isLoggedIn)
        .alert(isPresented: $viewModel.hasAlert) {
            Alert(with: viewModel.alert)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
    }
}



