//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Olga Trofimova on 01.07.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreAlertMessage = ""
    @State private var scoreAlertText = ""
    @State private var scoreAlert = 0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var currentFlagTap = 0
    @State private var correctChoice = false
    @State private var wrongChoice = false
    @State private var degreesForAnimation = 0.0
    @State private var opacityState = false
        
    var body: some View {
        ZStack {
//            Color.blue.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                ForEach (0..<3) { number in
                    Button(action: {
                            withAnimation {
                                self.flagTapped(number)
                            }
                    }) {
                        Image(self.countries[number])
        //  модификатор чтобы визуализировать пиксели исходного изображения, а не пытаться перекрашивать их как кнопку
                            .renderingMode(.original)
                            .flagImage()
                           
                     }
                    .rotation3DEffect(
                        .degrees(self.correctChoice && self.currentFlagTap == number ? 360 : 0 ), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .opacity(self.opacityState && !(self.currentFlagTap == number) ? 0.75 : 1)
                    .rotation3DEffect(
                        .degrees(self.wrongChoice && self.currentFlagTap == number ? 360 : 0 ), axis: (x: 0.0, y: 0.0, z: 1.0)
                    )

                }
                Text("Current score: \(scoreAlert)")
                    .foregroundColor(.white)
                    .font(.title2)
                Spacer()

            }
            
            .alert(isPresented: $showingScore){
                Alert(title: Text(scoreAlertMessage), message: Text("That’s the flag of \(scoreAlertText)"), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
            }

        }
    }
    
    func flagTapped(_ number: Int) {
        
        self.currentFlagTap = number
        if number == correctAnswer {
            scoreAlert = scoreAlert + 1
            scoreAlertMessage = "Correct"
            scoreAlertText = countries[number]
            correctChoice = true
            opacityState = true
        } else {
            scoreAlertMessage = "Wrong!"
            scoreAlertText = countries[number]
            if scoreAlert != 0 {
            scoreAlert = scoreAlert - 1
            } else {
                scoreAlert = 0
            }
            wrongChoice = true
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        correctChoice = false
        wrongChoice = false
        opacityState = false
    }
}

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: Color.blue, radius: 2)
    }
}

extension View {
    func flagImage() -> some View {
        self.modifier(FlagImage())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
