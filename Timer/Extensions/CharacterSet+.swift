//
//  CharacterSet+.swift
//  Timer
//
//  Created by jinwoong Kim on 4/12/24.
//

import Foundation

extension CharacterSet {
    func contains(_ character: Character) -> Bool {
        character.unicodeScalars.allSatisfy(contains(_:))
    }
}
