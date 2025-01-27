//
//  Region+FlagEmoji.swift
//  BirchFetchTakeHome
//
//  Created by George Birch on 1/26/25.
//

import Foundation

extension Locale.Region {
    
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
