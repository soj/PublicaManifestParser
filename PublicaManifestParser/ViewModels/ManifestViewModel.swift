//
//  ManifestViewModel.swift
//  PublicaManifestParser
//
//  Created by Sergey Mingalev on 21.05.2025.
//

import Foundation
import SwiftUI

@MainActor
class ManifestViewModel: ObservableObject {
    private let manifestProvider: any ManifestProvider
    private let parser: ManifestParser
    
    @Published private(set) var isLoading = false
    @Published private(set) var error: ManifestError?
    @Published private(set) var adBreaks: [AdBreak] = []

    init(manifestProvider: any ManifestProvider = LocalFileManifestProvider()) {
        self.manifestProvider = manifestProvider
        self.parser = ManifestParser()
    }
    
    func loadManifest() async {
        isLoading = true
        error = nil
        
        do {
            let content = try await manifestProvider.getManifestContent()
            try parser.parse(manifestContent: content)
            
            adBreaks = parser.getAdBreaks()
        } catch let manifestError as ManifestError {
            self.error = manifestError
        } catch {
            self.error = .parsingError
        }
        
        isLoading = false
    }
} 
