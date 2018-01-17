//
//  Hangman.swift
//  MeshMan
//
//  Created by Russell Pecka on 12/28/17.
//  Copyright © 2017 Russell Pecka. All rights reserved.
//

import Foundation

// MARK: - HangmanDelegate

internal class Hangman {
	
	internal enum Rules {
		static let numberOfGuesses = 9
		static let maxCharacters = 100
		static let minCharacters = 3
		static let wordSelectionBlurb = NSLocalizedString("The word you choose must be no shorter than %d characters and no longer than %d characters. Any characters other than numbers and letters will be shown to your opponents.\n\nFor Example:\n\nTHE CAT'S MEOW\nwill become\n_ _ _   _ _ _ ' _   _ _ _ _", comment: "Writeup of the rules around choosing a word in hangman")
	}
	
	private let word: String
	
	internal private(set) var obfuscatedWord: String
	
	private var guessedLetters = [Character]()
	
	internal private(set) var incorrectLetters = [Character]()
	
	internal let numberOfBlanks: Int
	
	init(word: String) {
		self.word = Hangman.sanitize(word: word)
		let (displayString, _, numberOfBlanks) = Hangman.obfuscate(word: self.word)
		self.obfuscatedWord = displayString
		self.numberOfBlanks = numberOfBlanks
	}
	
	internal enum GuessResult {
		case correct(String), alreadyGuessed(String), wrong(Character), invalid(String), wordGuessed(String), noMoreGuesses(Character, String)
	}
	
	internal func guess(letter: Character) -> GuessResult {
		let char = Character("\(letter)".uppercased())
		guard Hangman.characterIsValid(char) else { return .invalid("\(char)") }
		if guessedLetters.contains(char) {
			return .alreadyGuessed("\(char)")
		} else if word.contains(char) {
			self.guessedLetters.append(char)
			let (displayString, comparisonString, _) = Hangman.obfuscate(word: self.word, excluding: guessedLetters)
			self.obfuscatedWord = displayString
			if self.word == comparisonString {
				return .wordGuessed(comparisonString)
			} else {
				return .correct(displayString)
			}
		} else if self.incorrectLetters.count >= Rules.numberOfGuesses {
			self.guessedLetters.append(char)
			self.incorrectLetters.append(char)
			return .noMoreGuesses(char, self.word)
		} else {
			self.guessedLetters.append(char)
			self.incorrectLetters.append(char)
			return .wrong(char)
		}
	}
	
	// MARK: - Util
	
	internal enum ChoiceValidity {
		case tooShort, tooLong, good
	}
	
	internal static func checkValidChoice(_ text: String) -> ChoiceValidity {
		var count = 0
		for character in text.uppercased() {
			if self.characterIsValid(character) { count += 1 }
		}
		guard count >= Rules.minCharacters else { return .tooShort }
		guard count <= Rules.maxCharacters else { return .tooLong }
		return .good
	}
	
	internal static func sanitize(word: String) -> String {
		return word.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
	}
	
	internal static func obfuscate(word: String, excluding excludedCharacters: [Character] = []) -> (displayString: String, comparisonString: String, numberOfBlanks: Int) {
		var displayString = ""
		var comparisonString = ""
		var numberOfBlanks = 0
		let lastIndex = word.count - 1
		for (index, char) in word.enumerated() {
			var toAppend = index == 0 ? "" : " "
			if excludedCharacters.contains(char) {
				comparisonString.append(char)
				toAppend.append(char)
			} else if self.characterIsValid(char) {
				comparisonString.append("_")
				toAppend.append("_")
				numberOfBlanks += 1
			} else {
				comparisonString.append(char)
				toAppend.append(char)
			}
			if lastIndex == index {
				toAppend.append(" ")
			}
			displayString.append(toAppend)
		}
		return (displayString, comparisonString, numberOfBlanks)
	}
	
	internal static func characterIsValid(_ character: Character) -> Bool {
		guard let scalar = UnicodeScalar("\(character)") else { return false }
		return CharacterSet.uppercaseLetters.contains(scalar)
	}
	
}
