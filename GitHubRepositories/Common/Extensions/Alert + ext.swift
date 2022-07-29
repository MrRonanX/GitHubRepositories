//
//  Alert + ext.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/29/22.
//

import SwiftUI

extension Alert {
    init(with alert: AppAlert) {
        self.init(title: Text(alert.title), message: Text(alert.body), dismissButton: .default(Text("OK")))
    }
}
