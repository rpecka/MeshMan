//
//  HangmanGameState.swift
//  MeshMan
//
//  Created by Russell Pecka on 12/27/19.
//  Copyright © 2019 Russell Pecka. All rights reserved.
//

import Foundation


class HangmanGameState: Codable, Equatable {
    
    private let gameID = UUID()
    
    let word: String
    
    private(set) lazy var targetLetters: Set<Character> = Set<Character>(word.compactMap({ (char) -> Character? in
            guard Hangman.characterIsValid(char) else { return nil }
            return char
        }))
    
    private let guessedLetters: [String]
    
    private(set) lazy var guessedCharacters: Set<Character> = Set(guessedLetters.map({Character($0)}))
    
    private let incorrectLetters: [String]
    
    private(set) lazy var incorrectCharacters: Set<Character> = Set(incorrectLetters.map({Character($0)}))
    
    let pickerData: Data
    
    let guesserData: Data
    
    init(word: String, guessedLetters: [String] = [], incorrectLetters: [String] = [], pickerIDData: Data, guesserIDData: Data) {
        self.word = word
        self.guessedLetters = guessedLetters
        self.incorrectLetters = incorrectLetters
        self.pickerData = pickerIDData
        self.guesserData = guesserIDData
    }
    
    func make(guess letter: Character, nextGuesserData: Data) -> HangmanGameState {
        let newGuessedCharacters = guessedCharacters.union([letter])
        if targetLetters.contains(letter) {
            return HangmanGameState(word: word, guessedLetters: HangmanGameState.charactersToLetters(newGuessedCharacters), incorrectLetters: HangmanGameState.charactersToLetters(incorrectCharacters), pickerIDData: pickerData, guesserIDData: nextGuesserData)
        } else {
            let newIncorrectCharacters = incorrectCharacters.union([letter])
            return HangmanGameState(word: word, guessedLetters: HangmanGameState.charactersToLetters(newGuessedCharacters), incorrectLetters: HangmanGameState.charactersToLetters(newIncorrectCharacters), pickerIDData: pickerData, guesserIDData: nextGuesserData)
        }
    }
    
    private static func charactersToLetters(_ characters: Set<Character>) -> [String] {
        return characters.map {String($0)}
    }
    
    // MARK: - Equatable
    
    static func ==(lhs: HangmanGameState, rhs: HangmanGameState) -> Bool {
        return lhs.gameID == rhs.gameID
    }
    
}