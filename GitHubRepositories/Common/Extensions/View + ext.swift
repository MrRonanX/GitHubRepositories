//
//  View + ext.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/31/22.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
