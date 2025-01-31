//
//  Region+FlagEmoji.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/26/25.
//

import Foundation

extension Locale.Region {
    
    private static let adjectivalToCountryCode: [String: String] = [
            "American": "US",
            "British": "GB",
            "French": "FR",
            "Canadian": "CA",
            "Italian": "IT",
            "Malaysian": "MY",
            "Tunisian": "TN",
            "Greece": "GR",
            "Polish": "PL",
            "Portuguese": "PT",
            "Russian": "RU",
            "Croatian": "HR",
    ]
    
    init?(adjectival: String) {
        guard let countryCode = Self.adjectivalToCountryCode[adjectival] else {
            return nil
        }
        self.init(countryCode)
    }
    
    var flagEmoji: String? {
        guard self.identifier.count == 2 else { return nil }
        let lowercasedCode = self.identifier.lowercased()
        guard lowercasedCode.unicodeScalars.allSatisfy({ $0.value >= 0x61 && $0.value <= 0x7A }) else { return nil }
        
        let regionalIndicatorBase = UnicodeScalar(0x1F1E6)!.value - UnicodeScalar("a").value
        let indicatorSymbols = lowercasedCode.unicodeScalars.compactMap {
            UnicodeScalar(regionalIndicatorBase + $0.value)
        }
        
        return String(indicatorSymbols.map { Character($0) })
    }
}
