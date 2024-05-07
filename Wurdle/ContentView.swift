//
//  ContentView.swift
//  Wurdle

import SwiftUI

final class GuessState: ObservableObject {
    @Published
    var guess: String = ""
    @Published
    var guesses: [String] = []
    
    func validateGuess() {
        while guess.count > 5 {
            guess.removeLast()
        }
        guess = guess.trimmingCharacters(in: .letters.inverted)
    }
    
    func checkCompleteGuess() {
        if guess.count == 5 {
            guesses.append(guess)
            guess = ""
        }
    }
}

struct ContentView: View {
   
    @ObservedObject
    var state = GuessState()
    
    var body: some View {
        Header()
        ScrollView {
            TextInput(text: $state.guess, onEneterPressed: {
                state.checkCompleteGuess()
            })
                .opacity(0)
            LetterGrid(guess: state.guess, guesses: state.guesses)
                .padding()
        }.onChange(of: state.guess) {
            state.validateGuess()
        }
    }
}

struct Header: View {
    var body: some View {
        VStack(spacing: 3) {
            HStack {
                Text("Wurdle".uppercased())
                    .font(.largeTitle)
                    .bold()
            }
            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
        }
    }
}

struct TextInput: View {
    @Binding
    var text: String
    @FocusState
    var isFocused: Bool
    let onEneterPressed: () -> Void
    var body: some View {
        TextField("", text: $text)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.characters)
            .keyboardType(.asciiCapable)
            .focused($isFocused)
            .onChange(of: isFocused, perform: { newValue in
                if !newValue {
                    onEneterPressed()
                    isFocused = true
                }
            })
            .onAppear(perform: {
                isFocused = true
            })
    }
}

struct LetterGrid: View {
    let width = 5
    let height = 6
    let guess: String
    let guesses: [String]
    var body: some View {
        VStack {
            ForEach(0..<height, id: \.self) { row in
                HStack {
                    ForEach(0..<width, id: \.self) { col in
                        LetterView(letter: character(row: row, col: col))
                    }
                }
            }
        }
    }
    
    private func character(row: Int, col: Int) -> Character {
        var string: String = ""
        if row < guesses.count  {
            string = guesses[row]
        } else if row == guesses.count {
            string = guess
        }
        guard col < string.count else { return " " }
        return string[
            string.index(string.startIndex, offsetBy: col)
        ]
    }
}

struct LetterView: View {
    @State
    var filled: Bool = false
    var letter: Character = " "
    var scaleAmount: CGFloat = 1.4
    var body: some View {
        Color.clear
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(strokeColor, style: .init(lineWidth: 2))
                    .opacity(filled ? 0 : 1)
                    .animation(.none, value: filled)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(strokeColor, style: .init(lineWidth: 2))
                    .opacity(filled ? 1 : 0)
                    .scaleEffect(filled ? 1 : scaleAmount)
            }
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Text(String(letter))
                    .font(.system(size: 100))
                    .fontWeight(.heavy)
                    .scaleEffect(filled ? 1 : scaleAmount)
                    .minimumScaleFactor(0.1)
                    .padding(2)
            }
            .onChange(of: letter) { newLetter in
                withAnimation {
                    if letter.isWhitespace && !newLetter.isWhitespace {
                        filled = true
                    } else if !letter.isWhitespace && newLetter.isWhitespace {
                        filled = false
                    }
                }
            }
    }
    
    var strokeColor: Color {
        letter.isWhitespace ? Color.gray.opacity(0.3) : Color.black
    }
}

#Preview {
    ContentView()
}
