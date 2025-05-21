//
//  ManifestParser.swift
//  PublicaManifestParser
//
//  Created by Sergey Mingalev on 21.05.2025.
//

import Foundation

struct AdBreak {
    let startTime: TimeInterval
    let endTime: TimeInterval
    var duration: TimeInterval { endTime - startTime }
}

class ManifestParser {
    private var adBreaks: [AdBreak] = []
    private var currentTime: TimeInterval = 0
    private var isInAdBreak: Bool = false
    private var adBreakStartTime: TimeInterval = 0

    func parse(manifestContent: String) throws {
        adBreaks.removeAll()
        currentTime = 0
        isInAdBreak = false

        for rawLine in manifestContent.components(separatedBy: .newlines) {
            let line = rawLine.trimmingCharacters(in: .whitespaces)

            // Accumulate playback time from EXTINF tags
            if line.hasPrefix("#EXTINF:") {
                if let commaIndex = line.firstIndex(of: ",") {
                    let numStart = line.index(line.startIndex, offsetBy: 8)
                    let num = line[numStart..<commaIndex]
                    currentTime += TimeInterval(num) ?? 0
                }
            }
            
            // Paired discontinuity tags mark ad break start/end
            else if line.hasPrefix("#EXT-X-DISCONTINUITY") {
                if !isInAdBreak {
                    // Ad break start
                    isInAdBreak = true
                    adBreakStartTime = currentTime
                } else {
                    // Ad break end
                    let breakEndTime = currentTime
                    let adBreak = AdBreak(startTime: adBreakStartTime, endTime: breakEndTime)
                    adBreaks.append(adBreak)
                    isInAdBreak = false
                }
            }
        }

        // Close final ad break if manifest ends mid-break
        if isInAdBreak {
            let adBreak = AdBreak(startTime: adBreakStartTime, endTime: currentTime)
            adBreaks.append(adBreak)
        }
    }

    func getAdBreaks() -> [AdBreak] {
        return adBreaks
    }
}
