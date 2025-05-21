//
//  LocalFileManifestProvider.swift
//  PublicaManifestParser
//
//  Created by Sergey Mingalev on 21.05.2025.
//

import Foundation

protocol ManifestProvider {
    func getManifestContent() async throws -> String
}

class LocalFileManifestProvider: ManifestProvider {
    private let fileName: String
    private let fileExtension: String
    
    init(fileName: String = "manifest", fileExtension: String = "txt") {
        self.fileName = fileName
        self.fileExtension = fileExtension
    }
    
    func getManifestContent() async throws -> String {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            throw ManifestError.fileNotFound
        }
        
        return try String(contentsOf: fileURL, encoding: .utf8)
    }
}

enum ManifestError: Error {
    case fileNotFound
    case parsingError
} 
