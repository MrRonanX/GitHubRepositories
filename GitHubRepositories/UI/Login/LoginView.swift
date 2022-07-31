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
                mainImage
                    .frame(width: geo.size.width * 0.8)
                Button(action: viewModel.loginTapped) {
                    HStack {
                        buttonImage
                        buttonText
                    }
                    .frame(width: 280, height: 40)
                    .background(Color.buttonBackground)
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
                GRWebView(container: viewModel.container, request: viewModel.urlRequest)
                    .interactiveDismissDisabled()
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
    
    private var mainImage: some View {
        Image("gh-logo")
            .resizable()
            .scaledToFit()
    }
    
    private var buttonImage: some View {
        Image("gh-button-logo")
            .resizable()
            .scaledToFit()
            .frame(width: 32, height: 32)
    }
    
    private var buttonText: some View {
        Text("Log in  with GitHub")
            .foregroundColor(.white)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: .init(container: DIContainer.preview))
    }
}


