//
//  ContentView.swift
//  Morse Code
//
//  Created by Jimena De ceballos viadero on 16/9/22.
//

import SwiftUI
import AVFoundation

var letrasVocabulario: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", " "]
var morseVocabulario: [String] = [".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-", ".-..", "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-", "..-", "...-", ".--", "-..-", "-.--", "--..", ".----", "..---", "...--","....-",".....","-....","--...", "---..","----.","-----", "  "]


struct ContentView: View {
    @State var pestaña = 2
    
    var body: some View {
        TabView(selection: $pestaña) {
            Rules()
                .tabItem {
                    Image(systemName: "text.book.closed.fill")
                    Text("Rules")
                }
                .onTapGesture {
                    pestaña = 1
                }
                .tag(1)
            Menu()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .onTapGesture {
                    pestaña = 2
                }
                .tag(2)
            Play()
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Play")
                }
                .onTapGesture {
                    pestaña = 3
                }
                .tag(3)
        }
    }
}

struct Menu: View {
    @State private var Ascii: String = ""
    @State private var Morse: String = ""
    
    enum Fields {
        case ascii
        case morse
    }
    
    @FocusState var focusedField: Fields?
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @State private var indexStringFlash = 0
    @State private var iluminando = false
    @State private var MorseAFlash = ""
    
    func Translate(Line: String, Lenguage: Bool) -> String {
        var translation = ""
        if Lenguage {
            for char in Line.lowercased() {
                for item in 0 ... 36 {
                    if char == letrasVocabulario[item] {
                        translation += morseVocabulario[item] + "   "
                        if char == " "{
                            translation = String(translation.dropLast(3))
                        }
                    }
                }
            }
        }
        else{
            let line = Line.components(separatedBy: "   ")
            
            for item in line {
                if item.prefix(2) == "  " {
                    translation += " "
                    for a in 0 ... 36 {
                        if item.dropFirst(2) == morseVocabulario[a] {
                            translation += String(letrasVocabulario[a])
                        }
                    }
                }
                else {
                    for a in 0 ... 36 {
                        if item == morseVocabulario[a] {
                            translation += String(letrasVocabulario[a])
                        }
                    }
                }
            }
        }
        return translation
    }
    
    
    func MorseToOnOff() -> String {
        let onOffA = Morse.components(separatedBy: "     ")
        let onOffB = onOffA.joined(separator: "0000")
        let onOffC = onOffB.components(separatedBy: "   ")
        var onOff = onOffC.joined(separator: "00")
        onOff = onOff.replacingOccurrences(of: "-", with: "1110")
        onOff = onOff.replacingOccurrences(of: ".", with: "10")
        print(onOff)
        
        return onOff
    }
    
    func onOff() {
        let char = Array(MorseAFlash)
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (char[indexStringFlash] == "0") {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    var body: some View{
        VStack(alignment: .center) {
            Text("MORSE CODE")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(Color.blue)
            Divider()
            VStack(alignment: .leading){
                Text("Translator")
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray)
                VStack {
                    TextField("Ascii", text: $Ascii, axis: .vertical)
                        .autocorrectionDisabled()
                        .cornerRadius(2)
                        .shadow(radius: 1)
                        .lineLimit(4...4)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: Fields.ascii)
                    TextField("Morse", text: $Morse, axis: .vertical)
                        .autocorrectionDisabled()
                        .cornerRadius(2)
                        .shadow(radius: 1)
                        .lineLimit(4...4)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: Fields.morse)
                        
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("Cancel") {
                            focusedField = nil
                        }
                        Spacer()

                        Button("Done") {
                            if focusedField == Fields.morse {
                                Ascii = Translate(Line: Morse, Lenguage: false)
                            }
                            else{
                                Morse = Translate(Line: Ascii, Lenguage: true)
                            }
                            
                            focusedField = nil
                            
                        }
                     }
                }
                HStack(alignment: .center){
                    Button {
                        MorseAFlash = MorseToOnOff()
                        iluminando = true
                        indexStringFlash = 0
                    } label: {
                        HStack{
                            Text("flash")
                            Image(systemName: "flashlight.on.fill")
                        }
                    }
                    .onReceive(timer, perform: { _ in
                        if iluminando {
                            
                            if indexStringFlash >= MorseAFlash.count {
                                iluminando = false
                            }
                            else {
                                onOff()
                                indexStringFlash += 1
                            }
                            
                        }
                    })
                    .buttonStyle(.bordered)
                    Spacer()
                    Button {
                        UIPasteboard.general.setValue(Morse, forPasteboardType: "public.plain-text")
                    } label: {
                        HStack{
                            Text("copy")
                            Image(systemName: "doc.on.doc.fill")
                        }
                    }
                    .buttonStyle(.bordered)
                }
                .padding([.top, .leading, .trailing], 15.0)
            }
            .padding(.vertical, 10.0)
            
            Divider()
            Text("Add a morse keyboard on your device.")
            Button(action: {
                if let url = URL(string:"App-Prefs:General&path=Keyboard")
                {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }, label: {
                Label("Add Keyboard", systemImage: "keyboard")
            })
            .padding(5.0)
        }
        .padding(.horizontal, 10.0)
    }
}

struct Rules: View {
    var body: some View{
        VStack{
            Text("RULES")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(Color.blue)
                .padding(.bottom)
            Text("1 - The length of a dot is one unit.\n2 - A dash is three units.\n3 - The space between parts of the same letter is one unit.\n4 - The space between letter is three units.\n5 - The space between words is seven units.")
                .font(.callout)
            Divider()
            Image("reglas").resizable().scaledToFit()
        }
        .padding(.vertical, 15.0)
    }
}

struct Play: View {
    @State private var lives = 3
    @State private var points = 0
    @State private var countTimer = 5
    @State var timerIsRunning = true
    @State var randomInt = 0
    @State var jugando = false
    
    @State private var pregunta = "H"
    @State private var opcionA = "A"
    @State private var opcionB = "B"
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func NewGame() {
        lives = 3
        points = 0
        timerIsRunning = true
        NextMorse()
    }
    
    func NextMorse() {
        countTimer = 5
        randomInt = Int.random(in: 0..<36)
        pregunta = letrasVocabulario[randomInt].uppercased()
        if Int.random(in: 0..<2) == 1{
            opcionA = morseVocabulario[randomInt]
            var i = Int.random(in: 0..<36)
            while randomInt == i {
                i = Int.random(in: 0..<36)
            }
            opcionB = morseVocabulario[i]
        }
        else {
            opcionB = morseVocabulario[randomInt]
            var i = Int.random(in: 0..<36)
            while randomInt == i {
                i = Int.random(in: 0..<36)
            }
            opcionA = morseVocabulario[i]
            
        }
        if points > UserDefaults.standard.integer(forKey: "Puntos") {
            UserDefaults.standard.set(points, forKey: "Puntos")
        }
        timerIsRunning = true
    }
    
    var body: some View{
        if !jugando{
            VStack{
                Text("PLAY")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(Color.blue)
                    .padding(.bottom)
                Text("Height Score: \(UserDefaults.standard.integer(forKey: "Puntos"))")
                    .fontWeight(.thin)
                    .foregroundColor(Color.red)
                    .padding(.bottom)
                Button("Start"){
                    jugando = true
                    NewGame()
                }
                .buttonStyle(.bordered)
                .padding(.top)
            }
        }
        else {
            if lives > 0 {
                VStack{
                    Text("PLAY")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                        .padding(.bottom)
                    Text("\(points)")
                        .font(.title)
                        .fontWeight(.thin)
                        .padding(.vertical)
                        .foregroundColor(Color.blue)
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
                                if lives > 0 && timerIsRunning {
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
                    Text("\(pregunta)")
                        .font(.system(size: 150))
                        .fontWeight(.heavy)
                        .foregroundColor(Color.blue)
                    HStack {
                        Button {
                            if morseVocabulario[randomInt] == opcionA{
                                points += 1
                            }
                            else{
                                lives -= 1
                            }
                            NextMorse()
                        } label: {
                            Text(opcionA)
                                .frame(width: 70.0)
                        }
                        .buttonStyle(.bordered)
                        .font(.title)
                        Button {
                            if morseVocabulario[randomInt] == opcionB{
                                points += 1
                            }
                            else{
                                lives -= 1
                            }
                            NextMorse()
                        } label: {
                            Text(opcionB)
                                .frame(width: 70.0)
                        }
                        .buttonStyle(.bordered)
                        .font(.title)
                    }
                }
                .padding(.vertical, 15.0)
            } else {
                VStack{
                    Text("GAME OVER")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(Color.red)
                    Divider()
                    HStack {
                        Text("Total Score: ")
                        Text("\(points)")
                            .fontWeight(.heavy)
                            .foregroundColor(Color.blue)
                    }
                    .padding(.top, 20.0)
                    HStack {
                        Text("Height Score: ")
                            .fontWeight(.thin)
                            .foregroundColor(Color.red)
                        Text("\(UserDefaults.standard.integer(forKey: "Puntos"))")
                            .fontWeight(.heavy)
                            .foregroundColor(Color.red)
                    }
                    .padding(.top)
                    Button {
                        NewGame()
                    } label: {
                        Text("Try again")
                    }
                    .padding(.top)
                    .buttonStyle(.bordered)
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
