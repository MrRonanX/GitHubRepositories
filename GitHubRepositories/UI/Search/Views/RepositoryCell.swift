//
//  RepositoryCell.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/30/22.
//

import SwiftUI

struct RepositoryCell: View {
    
    @Environment(\.colorScheme) private var colorScheme
    let repository: Repository
    let parent: ViewParent
    
    @State var opened = false
    
    init(for repository: Repository, parent: ViewParent) {
        self.repository = repository
        self.parent = parent
    }
    
    var body: some View {
        HStack(alignment: .top) {
            leadingImage
            VStack(alignment: .leading) {
                Text(repository.fullName)
                    .foregroundColor(.blue)
                    .font(.system(size: 18))
                Text(repository.description)
                    .lineLimit(3)
                footerStatsView
            }
        }
        .onTapGesture(perform: postArticleSelected)
    }
    
    var leadingImage: some View {
        Image(systemName: "character.book.closed")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .padding(.top, 5)
            .foregroundColor(imageColor)
    }
    
    var footerStatsView: some View {
        HStack {
            starsView
            languageView
            GrayText(repository.licenseName)
            GrayText(repository.lastUpdate)
            
        }
        .font(.footnote)
        .lineLimit(1)
    }
    
    var starsView: some View {
        HStack {
            Image(systemName: "star")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.systemGray)
            GrayText(repository.stars)
        }
    }
    
    var languageView: some View {
        HStack {
            Circle()
                .frame(width: 15, height: 15)
                .foregroundColor(.green)
            GrayText(repository.language)
        }
    }
}

extension RepositoryCell {
    
    enum ViewParent {
        case search, history
        
        var notificationName: Notification.Name {
            switch self {
            case .search:   return .searchRepositoryTapped
            case .history:  return .historyRepositoryTapped
            }
        }
    }
    
    var imageColor: Color {
        opened ? .yellow : systemBlackColor
    }
    
    var systemBlackColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private func postArticleSelected() {
        NotificationCenter.default.post(name: parent.notificationName, object: nil, userInfo: [
            "url": repository.url,
            "id": repository.id
        ])
        
        guard parent == .search else { return }
        opened = true
    }
}

struct RepositoryCell_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryCell(for: .empty, parent: .search)
    }
}

fileprivate struct GrayText: View {
    
    let title: String
    
    init(_ text: String) {
        title = text
    }
    
    var body: some View {
        Text(title)
            .foregroundColor(.systemGray)
    }
}


