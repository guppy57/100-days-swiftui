//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Armaan Gupta on 4/22/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
	@State private var showingFinalRound = false
    @State private var scoreTitle = ""
	@State private var score = 0
	@State private var roundsPlayed = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
	
	@State private var userFlag = 0
	@State private var animationAmount = 0.0
	
	var roundsPerGame = 8
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
				Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
				Spacer()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
							userFlag = number
							
							withAnimation {
								animationAmount = 360
							}
							
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 5)
                        }
						.rotation3DEffect(.degrees(number == userFlag ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
				
				Spacer()
				Spacer()
				
				Text("Score: \(score)")
					.foregroundStyle(.white)
					.font(.title.bold())
				
				Text("Round: \(roundsPlayed)/\(roundsPerGame)")
					.foregroundStyle(.white)
					.font(.subheadline)
				
				Spacer()
            }
			.padding()
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(score)")
            }
			.alert("Game over", isPresented: $showingFinalRound) {
				Button("Start new game", action: restartGame)
			} message: {
				Text("Final score: \(score)")
			}
        }
    }
    
    func flagTapped(_ number: Int) {
		roundsPlayed += 1
		
        if number == correctAnswer {
			score += 1
            scoreTitle = "Correct"
        } else {
			var flagName = countries[number]
            scoreTitle = "Wrong! That's the flag of \(flagName)"
        }
		
		animationAmount = 0
		
		if (roundsPlayed == roundsPerGame) {
			showingFinalRound = true
		} else {
			showingScore = true
		}
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
	
	func restartGame() {
		countries.shuffle()
		score = 0
		roundsPlayed = 0
	}
}

#Preview {
    ContentView()
}
