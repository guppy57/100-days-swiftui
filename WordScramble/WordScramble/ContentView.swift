//
//  ContentView.swift
//  WordScramble
//
//  Created by Armaan Gupta on 4/25/25.
//

import SwiftUI

struct ContentView: View {
	@State private var usedWords = [String]()
	@State private var rootWord = ""
	@State private var newWord = ""
	@State private var errorTitle = ""
	@State private var errorMessage = ""
	@State private var showingError = false
	
	func startGame() {
		if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
			if let startWords = try? String(contentsOf: startWordsUrl) {
				let allWords = startWords.components(separatedBy: "\n")
				rootWord = allWords.randomElement() ?? "silkworm"
				return
			}
		}
	}
	
	func addNewWord() {
		let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		guard answer.count > 3 else { return }
	
		guard isNotRootWord(word: answer) else {
			wordError(title: "Lol", message: "Can't use rootword")
			return
		}

		guard isOriginal(word: answer) else {
			wordError(title: "Word used already", message: "Be more original")
			return
		}
		
		guard isPossible(word: answer) else {
			wordError(title: "Word not possible", message: "You can't spell that word.")
			return
		}
		
		guard isReal(word: answer) else {
			wordError(title: "Word not recognized", message: "You can't just make up a word!")
			return
		}
		
		withAnimation {
			usedWords.insert(answer, at: 0)
		}
		newWord = ""
	}
	
	func isOriginal(word: String) -> Bool {
		!usedWords.contains(word)
	}
	
	func isPossible(word: String) -> Bool {
		var tempWord = rootWord
		
		for letter in word {
			if let pos = tempWord.firstIndex(of: letter) {
				tempWord.remove(at: pos)
			} else {
				return false
			}
		}
		
		return true
	}
	
	func isReal(word: String) -> Bool {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.utf16.count)
		var misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
		
		return misspelledRange.location == NSNotFound
	}
	
	func isNotRootWord(word: String) -> Bool {
		return rootWord != word
	}
	
	func wordError(title: String, message: String) {
		errorTitle = title
		errorMessage = message
		showingError = true
	}
	
    var body: some View {
		NavigationStack {
			List {
				Section {
					TextField("Enter your word", text: $newWord)
						.textInputAutocapitalization(.never)
				}
				
				Section {
					ForEach(usedWords, id: \.self) { word in
						HStack {
							Image(systemName: "\(word.count).circle")
							Text(word)
						}
					}
				}
			}
			.navigationTitle(rootWord)
			.toolbar() {
				Button("Restart") {
					startGame()
				}
			}
			.onSubmit(addNewWord)
			.onAppear(perform: startGame)
			.alert(errorTitle, isPresented: $showingError) { } message: {
				Text(errorMessage)
			}
		}
    }
}

#Preview {
    ContentView()
}
