//
//  PublicaManifestParserTests.swift
//  PublicaManifestParserTests
//
//  Created by Sergey Mingalev on 21.05.2025.
//

import XCTest
@testable import PublicaManifestParser

final class PublicaManifestParserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoAdBreaks() throws {
        let manifest = """
        #EXTINF:5,
        #EXTINF:3,
        """

        let parser = ManifestParser()
        try parser.parse(manifestContent: manifest)
        let adBreaks = parser.getAdBreaks()
        XCTAssertEqual(adBreaks.count, 0)
    }

    func testSingleAdBreak() throws {
        let manifest = """
        #EXTINF:5,
        #EXTINF:10,
        #EXT-X-DISCONTINUITY
        #EXTINF:3,
        #EXT-X-DISCONTINUITY
        #EXTINF:2,
        """

        let parser = ManifestParser()
        try parser.parse(manifestContent: manifest)
        let adBreaks = parser.getAdBreaks()
        XCTAssertEqual(adBreaks.count, 1)
        let adBreak = adBreaks[0]
        XCTAssertEqual(adBreak.startTime, 15)
        XCTAssertEqual(adBreak.endTime, 18)
        XCTAssertEqual(adBreak.duration, 3)
    }

    func testUnclosedAdBreak() throws {
        let manifest = """
        #EXTINF:5,
        #EXT-X-DISCONTINUITY
        #EXTINF:3,
        """

        let parser = ManifestParser()
        try parser.parse(manifestContent: manifest)
        let adBreaks = parser.getAdBreaks()
        XCTAssertEqual(adBreaks.count, 1)
        let adBreak = adBreaks[0]
        XCTAssertEqual(adBreak.startTime, 5)
        XCTAssertEqual(adBreak.endTime, 8)
        XCTAssertEqual(adBreak.duration, 3)
    }

}
