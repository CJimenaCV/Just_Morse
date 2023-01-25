//  ContentView.swift
//  Just Morse Watch App
//
//  Created by Jimena De ceballos viadero on 21/9/22.
//

import SwiftUI

struct ContentView: View {
    @State var Jugando = false
    @State var Puntos = 0
    
    
    var body: some View {
        NavigationView{
            VStack {
                
                Text("Just MORSE")
                    .font(.title2)
                    .fontWeight(.thin)
                    .foregroundColor(Color.blue)
                    .multilineTextAlignment(.center)
                Divider()
                HStack {
                    Text("Heigh Score: ")
                    Text("\(UserDefaults.standard.integer(forKey: "Puntos"))")
                        .fontWeight(.heavy)
                        .foregroundColor(Color.blue)
                }
                .padding(.vertical)
                Spacer()
                NavigationLink(destination: Juego(Jugando: $Jugando)) {
                    Text("PLAY")
                        .font(.title3)
                }
                .padding(.horizontal, 20.0)
                
            }
            .padding()
            
            
        }
        .navigationBarHidden(true)
    }
}

struct Juego: View {
    @Binding var Jugando:Bool
    
    var letrasVocabulario: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "]
    var morseVocabulario: [String] = [".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-", ".-..", "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-", "..-", "...-", ".--", "-..-", "-.--", "--..", "  "]
    
    @State var lives = 3
    @State var countTimer = 5
    @State var timerIsRunning = true
    @State var randomInt = 0
    @State var Points = 0
    @State var opcionA = ""
    @State var opcionB = ""
    @State var Pregunta = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func NextMorse() {
        if lives > 0 {
            randomInt = Int.random(in: 0..<26)
            Pregunta = letrasVocabulario[randomInt].uppercased()
            if Int.random(in: 0..<2) == 1{
                opcionA = morseVocabulario[randomInt]
                var i = Int.random(in: 0..<26)
                while randomInt == i {
                    i = Int.random(in: 0..<26)
                }
                opcionB = morseVocabulario[i]
            }
            else {
                opcionB = morseVocabulario[randomInt]
                var i = Int.random(in: 0..<26)
                while randomInt == i {
                    i = Int.random(in: 0..<26)
                }
                opcionA = morseVocabulario[i]
                
            }
            
            if Points > UserDefaults.standard.integer(forKey: "Puntos") {
                UserDefaults.standard.set(Points, forKey: "Puntos")
            }
            
            countTimer = 5
            timerIsRunning = true
            Jugando = false
        }
    }
    
    
    var body: some View {
        if lives > 0 {
                VStack {
                    Spacer()
                    HStack {
                        
                        switch lives {
                        case 1:
                            Image(systemName: "heart.fill")
                        case 2:
                            HStack {
                                Image(systemName: "heart.fill")
                                Image(systemName: "heart.fill")
                            }
                        default:
                            HStack {
                                Image(systemName: "heart.fill")
                                Image(systemName: "heart.fill")
                                Image(systemName: "heart.fill")
                            }
                        }
                        Text("\(countTimer)")
                            .foregroundColor(Color.blue)
                            .onReceive(timer) { _ in
                                if lives > 0 {
                                    if countTimer > 0 && timerIsRunning
                                    {
                                        countTimer -= 1
                                    } else {
                                        timerIsRunning = false
                                        lives -= 1
                                        NextMorse()
                                    }
                                }
                            }
                    }
                    Divider()
                    Text("\(Points)")
                    .padding(.top)
                    Text("\(Pregunta)")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.blue)
                    HStack {
                        Button {
                            if morseVocabulario[randomInt] == opcionA{
                                Points += 1
                            }
                            else{
                                lives -= 1
                            }
                            NextMorse()
                        } label: {
                            Text(opcionA)
                        }
                        Button {
                            if morseVocabulario[randomInt] == opcionB{
                                Points += 1
                            }
                            else{
                                lives -= 1
                            }
                            NextMorse()
                        } label: {
                            Text(opcionB)
                        }
                    }
                    
                    
                }
                .padding(.top)
                .onAppear{
                    NextMorse()
                }
        }
        else {
            VStack{
                Text("GAME OVER")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(Color.red)
                Divider()
                Text("Score: \(Points)")
                    .padding(.vertical, 10.0)
                NavigationLink(destination: ContentView()) {
                    Text("Exit")
                }
                .padding(.horizontal, 20.0)
                
            }
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
