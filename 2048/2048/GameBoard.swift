//
//  GameBoard.swift
//  2048
//
//  Created by Nikolay Prodanow on 4/30/17.
//  Copyright © 2017 Nikolay Prodanow. All rights reserved.
//

import Foundation

class GameBoard {
    
    var isOutOfMoves: Bool {
        for rowOfNumbers in boardNumbers {
            for number in rowOfNumbers {
                if number == 0 {
                    return false
                }
            }
        }
        
        for row in 0..<boardNumbers.count {
            for col in 0..<boardNumbers[row].count - 1 {
                if boardNumbers[row][col] == boardNumbers[row][col + 1] {
                    return false
                }
            }
        }
        
        for col in 0..<boardNumbers.count {
            for row in 0..<boardNumbers.count - 1 {
                if boardNumbers[row][col] == boardNumbers[row + 1][col] {
                    return false
                }
            }
        }
        
        return true
    }
    
    private var boardNumbers: [[Int]]
    
    init(withNumbers numbers: [[Int]]) {
        boardNumbers = numbers
    }
    
    subscript(row: Int, col: Int)  -> String? {
        get {
            if boardNumbers[row][col] == 0 {
                return nil
            }
            
            return boardNumbers[row][col].description
        }
        
        set {
            if let newValue = newValue,
                let newNumber = Int(newValue){
                boardNumbers[row][col] = newNumber
            }
        }
    }
    
    func getBoardNumbers() -> [[Int]] {
        return boardNumbers
    }
    
    func setBoardNumbers(newNumbers: [[Int]]) throws {
        if newNumbers.count != 4  ||
            newNumbers[0].count != 4 ||
            newNumbers[1].count != 4 ||
            newNumbers[2].count != 4 ||
            newNumbers[3].count != 4 {
            throw GameBoardError.InvalidBoardNumbers
        }
        
        boardNumbers = newNumbers
    }
}
