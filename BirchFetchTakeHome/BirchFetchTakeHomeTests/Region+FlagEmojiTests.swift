//
//  Region+FlagEmojiTests.swift
//  BirchFetchTakeHomeTests
//
//  Created by George Birch on 1/26/25.
//

@testable import BirchFetchTakeHome
import XCTest

final class Region_FlagEmojiTests: XCTestCase {
    
    private let testAdjectives = [
        "American",
        "British",
        "French",
        "Canadian",
        "Italian",
        "Malaysian",
        "Tunisian",
        "Greek",
        "Polish",
        "Portuguese",
        "Russian",
        "Croatian"
    ]
    private let testLocales: [Locale.Region] = [
        .unitedStates,
        .unitedKingdom,
        .france,
        .canada,
        .italy,
        .malaysia,
        .tunisia,
        .greece,
        .poland,
        .portugal,
        .russia,
        .croatia
    ]

    func testAdjectivalInit() {
        for i in 0..<testAdjectives.count {
            XCTAssertEqual(
                Locale.Region(adjectival: testAdjectives[i]),
                testLocales[i],
                "Adjectival form \(testAdjectives[i]) unexpectedly initialized as \(Locale.Region(adjectival: testAdjectives[i]) ?? "nil")"
            )
        }
    }
    
    func testFlags() {
        let expectedFlags = [
            "🇺🇸",
            "🇬🇧",
            "🇫🇷",
            "🇨🇦",
            "🇮🇹",
            "🇲🇾",
            "🇹🇳",
            "🇬🇷",
            "🇵🇱",
            "🇵🇹",
            "🇷🇺",
            "🇭🇷",
        ]
        for i in 0..<testLocales.count {
            XCTAssertEqual(
                testLocales[i].flagEmoji,
                expectedFlags[i],
                "Locale \(testLocales[i]) incorrectly translated to emoji \(testLocales[i].flagEmoji ?? "nil")"
            )
        }
    }
}
