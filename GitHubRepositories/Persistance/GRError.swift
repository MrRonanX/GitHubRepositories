//
//  GRError.swift
//  GitHubRepositories
//
//  Created by Roman Kavinskyi on 7/30/22.
//

import Foundation

enum GRError: String, Error {
    case unableToSave = "There was an error saving vehicles"
    case unableToLoad = "There was an error loading vehicles"
    case alreadySaved = "This repo is already saved"
}
