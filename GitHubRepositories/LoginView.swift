//
//  LoginView.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import SwiftUI

struct LoginView: View {

    @StateObject var viewModel: ViewModel
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                Image("gh-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.8)
                Button(action: loginTapped) {
                    
                    HStack {
                        Image("gh-button-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                        
                        Text("Log in  with GitHub")
                            .foregroundColor(.white)
                    }
                    .frame(width: 280, height: 40)
                    .background(Color(uiColor: UIColor(red: 23/255, green: 21/255, blue: 22/255, alpha: 1)))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white)
                    )
                }
                
                
                Spacer()
                    
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            .sheet(isPresented: $viewModel.showWebView) {
                GHWebView(isPresented: $viewModel.showWebView, container: viewModel.container, url: viewModel.urlRequest)
            }
        }
    }
    
    func loginTapped() {
        viewModel.loggedIn()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: .init(container: DIContainer.preview))
    }
}

extension LoginView {
    final class ViewModel: ObservableObject {
        
        @Published var showWebView = false
        
        let container: DIContainer
        
        var urlRequest: URLRequest {
            container.services.authService.authCodeRequest()
        }
        
        init(container: DIContainer) {
            self.container = container
        }
        
        func loggedIn() {
           showWebView = true
        }
    }
}
