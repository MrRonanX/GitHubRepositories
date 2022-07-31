//
//  SearchField.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import SwiftUI

struct SearchField: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var focusState: Bool
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        HStack(spacing: 30) {
            ZStack {
                if !viewModel.isSearchFocused && viewModel.searchQuery.isEmpty {
                    inactiveSearch
                }
                activeSearch
            }
            .frame(height: 60)
            .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(systemBlackColor.opacity(0.25)))
            
            if !viewModel.searchResults.isEmpty {
                Button("Close", action: closeTapped)
                    .foregroundColor(systemBlackColor)
            }
        }
        .animation(.easeIn(duration: 0.1), value: viewModel.isSearchFocused)
        .animation(.linear(duration: 0.2), value: viewModel.searchResults.isEmpty)
    }
    
    private var inactiveSearch: some View {
        HStack {
            searchImage
            Text("Search")
                .lineLimit(1)
                .foregroundColor(systemBlackColor)
        }
    }
    
    private var searchImage: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(systemBlackColor)
    }
    
    private var activeSearch: some View {
        HStack {
            if viewModel.isSearchFocused || !viewModel.searchQuery.isEmpty {
                searchImage
            }
            
            TextField("", text: $viewModel.searchQuery)
                .keyboardType(.webSearch)
                .focused($focusState)
                .submitLabel(.search)
                .autocapitalization(.sentences)
                .disableAutocorrection(true)
                .font(.system(size: 17))
                .foregroundColor(systemBlackColor)
                .onChange(of: focusState, perform: focusChanged)
            
            if !viewModel.searchQuery.isEmpty {
                Image(systemName: "xmark")
                    .foregroundColor(systemBlackColor)
                    .onTapGesture(perform: clearTapped)
            }
            
            if viewModel.isSearchFocused && viewModel.searchQuery.isEmpty {
                Image(systemName: "chevron.right")
                    .foregroundColor(systemBlackColor)
            }
        }
        .padding(.horizontal, 30)
    }
}

extension SearchField {
    
    private var systemBlackColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var systemWhiteColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    private func focusChanged(_ focus: Bool) {
        viewModel.isSearchFocused = focus
    }
    
    private func closeTapped() {
        viewModel.searchQuery = ""
        focusState = false
        viewModel.isSearchFocused = false
        viewModel.endSearching()
    }
    
    private func clearTapped() {
        viewModel.searchQuery = ""
    }
}


struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField(viewModel: .init(container: DIContainer.preview))
    }
}



