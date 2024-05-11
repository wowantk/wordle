//
//  LetterStatus.swift
//  Wurdle
//
//  Created by Volodymyr Drobot on 12.05.2024.
//

import Foundation

enum LetterStatus: Equatable {
    case notRevild
    case correct
    case misplased
    case notInWord
}

struct LetterGuess: Equatable {
    var status: LetterStatus = .notRevild
    let char: Character
    
    static var blank: Self {
        .init(char: " ")
    }
}

struct Guess: Equatable {
    private let letters: [LetterGuess]
    
    var count: Int {
        letters.count
    }
    
    subscript(index: Int) -> LetterGuess {
        get {
            letters[index]
        }
    }
    
    static func inProgress(_ input: String) -> Self {
        .init(letters: input.map({ char in
                .init(status: .notRevild, char: char)
        }))
    }
    
    static func evaluate(_ input: String, against word: String) -> Self {
        .init(letters: input.enumerated().map({ (index, character) in
            let letterStatus: LetterStatus
            let wordIndex = word.index(word.startIndex, offsetBy: index)
            if word[wordIndex] == character {
                letterStatus = .correct
            } else if word.contains(character) {
                letterStatus = .misplased
            } else {
                letterStatus = .notInWord
            }
            return .init(status: letterStatus, char: character)
        }))
        
    }
}
