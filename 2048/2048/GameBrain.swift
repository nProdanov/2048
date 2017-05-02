//
//  GameBrain.swift
//  2048
//
//  Created by Nikolay Prodanow on 4/30/17.
//  Copyright © 2017 Nikolay Prodanow. All rights reserved.
//

import Foundation

class GameBrain {
    
    // Constants
    let startMaxNumber = 2
    // end of Constants
    
    var maxNumber = 2
    
    func sum(numbers: [[Int]], inDirection direction: Direction, score: Int) -> ([[Int]], Int) {
        switch direction {
        case .Left: return sumLeft(withNumbers: numbers, score: score)
        case .Right: return sumRight(withNumbers: numbers, score: score)
        case .Up: return sumUp(withNumbers: numbers, score: score)
        case .Down: return sumDown(withNumbers: numbers, score: score)
        }
    }
    
    func generateNewBoardNumbers() -> [[Int]] {
        var numbers: [[Int]] = [[0, 0, 0, 0],
                                [0, 0, 0, 0],
                                [0, 0, 0, 0],
                                [0, 0, 0, 0]]
        
        numbers = generateNewNumber(inNumbers: numbers)
        numbers = generateNewNumber(inNumbers: numbers)
        
        return numbers
    }
    
    private func areEquals(oldNumbers: [[Int]], withNewNumbers newNumbers: [[Int]]) -> Bool {
        for row in 0..<oldNumbers.count {
            for col in 0..<oldNumbers[row].count {
                if oldNumbers[row][col] != newNumbers[row][col] {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func generateNewNumber(inNumbers numbers: [[Int]]) -> [[Int]] {
        var randomRow = Int(arc4random_uniform(UInt32(numbers.count)))
        var randomCol = Int(arc4random_uniform(UInt32(numbers.count)))
        
        while numbers[randomRow][randomCol] != 0 {
            randomRow = Int(arc4random_uniform(UInt32(numbers.count)))
            randomCol = Int(arc4random_uniform(UInt32(numbers.count)))
        }
        
        var newNumbers = numbers
        newNumbers[randomRow][randomCol] = 2
        
        return newNumbers
    }
    
    private func sumLeft(withNumbers numbers: [[Int]], score: Int) -> ([[Int]], Int) {
        var newNumbers: [[Int]] = [[], [], [], []]
        var newScore = score
        
        for row in 0..<numbers.count {
            var rowOfNumbers = numbers[row]
            
            var firstNumber = 0
            var secondNumber = 0
            
            for index in 0..<rowOfNumbers.count {
                if firstNumber != 0 {
                    if secondNumber != 0 {
                        if firstNumber == secondNumber {
                            newNumbers[row].append(2 * firstNumber)
                            
                            maxNumber = maxNumber < 2 * firstNumber ? 2 * firstNumber : maxNumber
                            
                            newScore = increaseScore(newScore)
                            firstNumber = rowOfNumbers[index]
                            secondNumber = 0
                        } else {
                            newNumbers[row].append(firstNumber)
                            
                            firstNumber = secondNumber
                            secondNumber = rowOfNumbers[index]
                        }
                        
                        continue
                    } else {
                        secondNumber = rowOfNumbers[index]
                        continue
                    }
                } else {
                    firstNumber = rowOfNumbers[index]
                    continue
                }
            }
            
            if firstNumber != 0 {
                if secondNumber != 0 {
                    if firstNumber == secondNumber {
                        newNumbers[row].append(2 * firstNumber)
                        
                        maxNumber = maxNumber < 2 * firstNumber ? 2 * firstNumber : maxNumber
                        newScore = increaseScore(newScore)
                    } else {
                        newNumbers[row].append(firstNumber)
                        newNumbers[row].append(secondNumber)
                    }
                } else {
                    newNumbers[row].append(firstNumber)
                }
            }
            
            if newNumbers[row].count < 4 {
                for _ in 0..<(4 - newNumbers[row].count) {
                    newNumbers[row].append(0)
                }
            }
        }
        
        if !areEquals(oldNumbers: numbers, withNewNumbers: newNumbers) {
            newNumbers = generateNewNumber(inNumbers: newNumbers)
        }
        
        return (newNumbers, newScore)
    }
    
    private func sumRight(withNumbers numbers: [[Int]], score: Int) -> ([[Int]], Int) {
        var newNumbers: [[Int]] = [[], [], [], []]
        var newScore = score
        
        for row in 0..<numbers.count {
            var rowOfNumbers = numbers[row]
            
            var firstNumber = 0
            var secondNumber = 0
            
            for index in (0...rowOfNumbers.count - 1).reversed() {
                if firstNumber != 0 {
                    if secondNumber != 0 {
                        if firstNumber == secondNumber {
                            newNumbers[row].append(2 * firstNumber)
                            
                            maxNumber = maxNumber < 2 * firstNumber ? 2 * firstNumber : maxNumber
                            newScore = increaseScore(newScore)
                            
                            firstNumber = rowOfNumbers[index]
                            secondNumber = 0
                        } else {
                            newNumbers[row].append(firstNumber)
                            
                            firstNumber = secondNumber
                            secondNumber = rowOfNumbers[index]
                        }
                    } else {
                        secondNumber = rowOfNumbers[index]
                        continue
                    }
                } else {
                    firstNumber = rowOfNumbers[index]
                    continue
                }
            }
            
            if firstNumber != 0 {
                if secondNumber != 0 {
                    if firstNumber == secondNumber {
                        newNumbers[row].append(2 * firstNumber)
                        
                        maxNumber = maxNumber < 2 * firstNumber ? 2 * firstNumber : maxNumber
                        newScore = increaseScore(newScore)
                    } else {
                        newNumbers[row].append(firstNumber)
                        newNumbers[row].append(secondNumber)
                    }
                } else {
                    newNumbers[row].append(firstNumber)
                }
            }
            
            newNumbers[row] = newNumbers[row].reversed()
            
            if newNumbers[row].count < 4 {
                for _ in 0..<(4 - newNumbers[row].count) {
                    newNumbers[row].insert(0, at: newNumbers.startIndex)
                }
            }
        }
        
        if !areEquals(oldNumbers: numbers, withNewNumbers: newNumbers) {
            newNumbers = generateNewNumber(inNumbers: newNumbers)
        }
        
        return (newNumbers, newScore)
    }
    
    private func sumUp(withNumbers numbers: [[Int]], score: Int) -> ([[Int]], Int) {
        var newNumbers: [[Int]] = [[], [], [], []]
        var newScore = score
        
        for col in 0..<numbers.count {
            
            var firstNumber = 0
            var secondNumber = 0
            
            for row in 0..<numbers.count {
                if firstNumber != 0 {
                    if secondNumber != 0 {
                        if firstNumber == secondNumber {
                            newNumbers[col].append(2 * firstNumber)
                            
                            maxNumber = maxNumber < 2 * firstNumber ? 2 * firstNumber : maxNumber
                            newScore = increaseScore(newScore)
                            
                            firstNumber = numbers[row][col]
                            secondNumber = 0
                        } else {
                            newNumbers[col].append(firstNumber)
                            
                            firstNumber = secondNumber
                            secondNumber = numbers[row][col]
                        }
                    } else {
                        secondNumber = numbers[row][col]
                        continue
                    }
                } else {
                    firstNumber = numbers[row][col]
                    continue
                }
            }
            
            if firstNumber != 0 {
                if secondNumber != 0 {
                    if firstNumber == secondNumber {
                        newNumbers[col].append(2 * firstNumber)
                        
                        maxNumber = maxNumber < 2 * firstNumber ? 2 * firstNumber : maxNumber
                        newScore = increaseScore(newScore)
                    } else {
                        newNumbers[col].append(firstNumber)
                        newNumbers[col].append(secondNumber)
                    }
                } else {
                    newNumbers[col].append(firstNumber)
                }
            }
            
            if newNumbers[col].count < 4 {
                for _ in 0..<(4 - newNumbers[col].count) {
                    newNumbers[col].append(0) //insert(0, at: newNumbers.startIndex)
                }
            }
        }
        
        var revertedNewNumbers: [[Int]] = []
        
        for col in 0..<newNumbers.count {
            var currentRow: [Int] = []
            
            for row in 0..<newNumbers.count {
                currentRow.append(newNumbers[row][col])
            }
            
            revertedNewNumbers.append(currentRow)
        }
        
        if !areEquals(oldNumbers: numbers, withNewNumbers: revertedNewNumbers) {
            revertedNewNumbers = generateNewNumber(inNumbers: revertedNewNumbers)
        }
        
        return (revertedNewNumbers, newScore)
    }
    
    private func sumDown(withNumbers numbers: [[Int]], score: Int) -> ([[Int]], Int) {
        var newNumbers: [[Int]] = [[], [], [], []]
        var newScore = score
        
        for col in 0..<numbers.count {
            
            var firstNumber = 0
            var secondNumber = 0
            
            for row in (0..<numbers.count).reversed() {
                if firstNumber != 0 {
                    if secondNumber != 0 {
                        if firstNumber == secondNumber {
                            newNumbers[col].append(2 * firstNumber)
                            
                            maxNumber = maxNumber < 2 * firstNumber ? 2 * firstNumber : maxNumber
                            newScore = increaseScore(newScore)
                            
                            firstNumber = numbers[row][col]
                            secondNumber = 0
                        } else {
                            newNumbers[col].append(firstNumber)
                            
                            firstNumber = secondNumber
                            secondNumber = numbers[row][col]
                        }
                    } else {
                        secondNumber = numbers[row][col]
                        continue
                    }
                } else {
                    firstNumber = numbers[row][col]
                    continue
                }
            }
            
            if firstNumber != 0 {
                if secondNumber != 0 {
                    if firstNumber == secondNumber {
                        newNumbers[col].append(2 * firstNumber)
                        
                        maxNumber = maxNumber < 2 * firstNumber ? 2 * firstNumber : maxNumber
                        newScore = increaseScore(newScore)
                    } else {
                        newNumbers[col].append(firstNumber)
                        newNumbers[col].append(secondNumber)
                    }
                } else {
                    newNumbers[col].append(firstNumber)
                }
            }
            
            newNumbers[col] = newNumbers[col].reversed()
            
            if newNumbers[col].count < 4 {
                for _ in 0..<(4 - newNumbers[col].count) {
                    newNumbers[col].insert(0, at: newNumbers.startIndex)
                }
            }
        }
        
        var revertedNewNumbers: [[Int]] = []
        
        for col in 0..<newNumbers.count {
            var currentRow: [Int] = []
            
            for row in 0..<newNumbers.count {
                currentRow.append(newNumbers[row][col])
            }
            
            revertedNewNumbers.append(currentRow)
        }
        
        if !areEquals(oldNumbers: numbers, withNewNumbers: revertedNewNumbers) {
            revertedNewNumbers = generateNewNumber(inNumbers: revertedNewNumbers)
        }
        
        return (revertedNewNumbers, newScore)
    }
    
    private func increaseScore(_ score: Int) -> Int {
        let maxNumberBonusScore = Int(log2(Double(maxNumber))) * 3
        return score + maxNumberBonusScore + 3
    }
}
