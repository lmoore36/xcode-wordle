import SwiftUI

struct ContentView: View {
    @State private var guessWord: String = ""
    @State private var secretWord: String = ""
    @State private var turnNumber: Int = 1
    @State private var message: String = ""
    @State private var results: [String] = []
    @State private var isGameOver: Bool = false
    @State private var wordList: [String] = []
    
    var body: some View {
        VStack {
            Text("Wordle")
                .font(.largeTitle)
                .padding()
               
            Text("Turn \(turnNumber)/6")
                .font(.headline)
               
            if !isGameOver {
                TextField("Enter a \(secretWord.count)-letter word", text: $guessWord, onCommit: {
                    if guessWord.count == secretWord.count {
                        processGuess()
                    } else {
                        message = "That wasn't \(secretWord.count) chars! Try again."
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            }
               
            VStack {
                ForEach(results, id: \.self) { result in
                    Text(result)
                        .font(.largeTitle)
                }
            }
            .padding()
               
            Text(message)
                .foregroundColor(.red)
                .padding()
               
            if isGameOver {
                Button("Restart Game") {
                    restartGame()
                }
                .padding()
            }
        }
        .padding()
        .onAppear(perform: loadWords)
    }
       
    func processGuess() {
        message = ""
        let processedResult = emojified(guessWord.lowercased(), secretWord.lowercased())
        results.append(processedResult)
        if guessWord.lowercased() == secretWord.lowercased() {
            message = "You won in \(turnNumber)/6 turns!"
            isGameOver = true
        } else {
            turnNumber += 1
            if turnNumber > 6 {
                message = "X/6 - Sorry, try again tomorrow!"
                isGameOver = true
            }
        }
        guessWord = ""
    }
       
    func emojified(_ guessWord: String, _ secretWord: String) -> String {
        let greenBox = "\u{1F7E9}"
        let whiteBox = "\u{2B1C}"
        let yellowBox = "\u{1F7E8}"
        var resultString = ""
           
        for (index, guessChar) in guessWord.enumerated() {
            if secretWord.contains(guessChar) {
                if secretWord[secretWord.index(secretWord.startIndex, offsetBy: index)] == guessChar {
                    resultString += greenBox
                } else {
                    resultString += yellowBox
                }
            } else {
                resultString += whiteBox
            }
        }
        return resultString
    }
       
    func restartGame() {
        turnNumber = 1
        message = ""
        results = []
        isGameOver = false
        if !wordList.isEmpty {
            secretWord = wordList.randomElement() ?? "apple"
        }
    }
    
    func loadWords() {
        if let filePath = Bundle.main.path(forResource: "valid-words", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filePath)
                wordList = contents.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { $0.count == 5 }
                if let randomWord = wordList.randomElement() {
                    secretWord = randomWord
                }
            } catch {
                print("Error loading words from file: \(error)")
            }
        } else {
            print("File not found")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
