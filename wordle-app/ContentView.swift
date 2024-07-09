import SwiftUI

struct ContentView: View {
    @State private var guessWord: String = ""
    @State private var secretWord: String = "julia"
    @State private var turnNumber: Int = 1
    @State private var message: String = ""
    @State private var results: [String] = []
    @State private var isGameOver: Bool = false

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
                .disabled(isGameOver)
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
        secretWord = "julia" // You can randomize or change the secret word as needed
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
