//
//  ContentView.swift
//  Wurdle
//
//  Created by Volodymyr Drobot on 29.04.2024.
//

import SwiftUI

struct ContentView: View {
    @State
    var guess: String = ""
    var body: some View {
        Header()
        ScrollView {
            TextInput(text: $guess)
                .opacity(0)
            LetterGrid(guess: guess)
                .padding()
        }.onChange(of: guess) {
            while guess.count > 5 {
                guess.removeLast()
            }
            guess = guess.trimmingCharacters(in: .letters.inverted)
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
    var body: some View {
        TextField("", text: $text)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.characters)
            .keyboardType(.asciiCapable)
            .focused($isFocused)
            .onAppear(perform: {
                isFocused = true
            })
    }
}

struct LetterGrid: View {
    let width = 5
    let height = 6
    @State
    var activeRow = 0
    var guess: String
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
        guard row == activeRow else { return " " }
        guard col < guess.count else { return " " }
        return guess[
            guess.index(guess.startIndex, offsetBy: col)
        ]
    }
}

struct LetterView: View {
    var letter: Character = " "
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(Color.gray.opacity(0.3), style: .init(lineWidth: 2))
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                Text(String(letter))
                    .font(.system(size: 100))
                    .minimumScaleFactor(0.1)
                    .padding(2)
            }
    }
}

#Preview {
    ContentView()
}
