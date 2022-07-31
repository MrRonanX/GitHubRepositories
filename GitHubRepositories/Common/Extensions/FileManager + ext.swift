//
//  FileManager + ext.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/31/22.
//

import Foundation

extension FileManager {
    func fileUrl(with fileName: String) -> URL? {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let editedName = fileName.replacingOccurrences(of: "/", with: "-")
        return documentsUrl.appendingPathComponent(editedName)
    }
}
