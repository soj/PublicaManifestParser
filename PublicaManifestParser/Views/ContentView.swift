//
//  ContentView.swift
//  PublicaManifestParser
//
//  Created by Sergey Mingalev on 21.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ManifestViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading manifest...")
                } else if let error = viewModel.error {
                    VStack {
                        Text("Error: \(error.localizedDescription)")
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task {
                                await viewModel.loadManifest()
                            }
                        }
                    }
                } else {
                    List {
                        Section("Manifest Info") {
                            HStack {
                                Text("Ad Breaks")
                                Spacer()
                                Text("\(viewModel.adBreaks.count)")
                            }
                        }

                        if !viewModel.adBreaks.isEmpty {
                            Section("Ad Breaks") {
                                ForEach(viewModel.adBreaks, id: \.startTime) { adBreak in
                                    VStack(alignment: .leading) {
                                        Text("Start: \(formatDuration(adBreak.startTime))")
                                        Text("End: \(formatDuration(adBreak.endTime))")
                                        Text("Duration: \(formatDuration(adBreak.duration))")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Manifest Parser")
            .task {
                await viewModel.loadManifest()
            }
        }
    }

    private func formatDuration(_ duration: Double) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
