//
//  HistoryView.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import SwiftUI

struct HistoryView: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.repositories) { repository in
                        RepositoryCell(for: repository, parent: .history)
                    }
                }
            }
            .padding(.horizontal)
            .onAppear(perform: viewModel.loadHistory)
            .navigationTitle("History")
            .onTapGesture(perform: hideKeyboard)
            .highPriorityGesture(DragGesture().onChanged { _ in
                hideKeyboard()
            })
            .sheet(item: $viewModel.selectedURL) {
                GRWebView(container: viewModel.container, request: URLRequest(url: $0))
            }
            
        }
        .navigationViewStyle(.stack)
        
    }
    

}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(viewModel: .init(.preview))
    }
}
