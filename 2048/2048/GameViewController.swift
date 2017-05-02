//
//  GameViewController.swift
//  2048
//
//  Created by Nikolay Prodanow on 4/30/17.
//  Copyright © 2017 Nikolay Prodanow. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // Constants
    let highScoreKey = "highScore"
    
    let startingScore = "0"
    
    let cellReuseIdentifier = "Cell"
    let cellAcross = 4
    let spaceBetweenCells: CGFloat = 5
    // end of Constants
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gameOverView: UIView!
    
    @IBAction func newGameButton() {
        scoreLabel.text = startingScore
        guard let gameBrain = gameBrain else { return }
        do {
            try gameBoard?.setBoardNumbers(newNumbers: gameBrain.generateNewBoardNumbers())
            collectionView.reloadData()
        } catch let error {
            print(error)
        }
    }
    
    var gameBoard: GameBoard?
    var gameBrain: GameBrain?
    
    var score: Int? {
        get {
            guard let scoreText = scoreLabel.text else { return nil }
            return Int(scoreText)
        }
        
        set {
            scoreLabel.text = newValue?.description
        }
    }
    
    var highScore: Int? {
        get {
            guard let highScoreText = highScoreLabel.text else { return nil }
            return Int(highScoreText)
        }
        
        set {
            highScoreLabel.text = newValue?.description
            UserDefaults.standard.set(newValue?.description, forKey: highScoreKey)
        }
    }
    
    override func viewDidLoad() {
        gameOverView.isHidden = true
        gameBrain = GameBrain()
        
        guard let gameBrain = gameBrain else { return }
        gameBoard = GameBoard(withNumbers: (gameBrain.generateNewBoardNumbers()))
        
        scoreLabel.text = startingScore
        highScoreLabel.text = UserDefaults.standard.string(forKey: highScoreKey) ?? startingScore
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(sum))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(sum))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(sum))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        view.addGestureRecognizer(swipeUp)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(sum))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeft)
    }
    
    func sum(gesture: UIGestureRecognizer) {
        if let gesture = gesture as? UISwipeGestureRecognizer,
            let oldNumbers = gameBoard?.getBoardNumbers(),
            let score = score,
            let highScore = highScore,
            let gameBrain = gameBrain {
            
            let (newNumbers, newScore): ([[Int]], Int)
            
            switch gesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                (newNumbers, newScore) = gameBrain.sum(numbers: oldNumbers, inDirection: .Left, score: score)
            case UISwipeGestureRecognizerDirection.right:
                (newNumbers, newScore) = gameBrain.sum(numbers: oldNumbers, inDirection: .Right, score: score)
            case UISwipeGestureRecognizerDirection.up:
                (newNumbers, newScore) = gameBrain.sum(numbers: oldNumbers, inDirection: .Up, score: score)
            case UISwipeGestureRecognizerDirection.down:
                (newNumbers, newScore) = gameBrain.sum(numbers: oldNumbers, inDirection: .Down, score: score)
            default:
                (newNumbers, newScore) = (oldNumbers, score)
            }
            
            do {
                guard let gameBoard = gameBoard else { return }
                try gameBoard.setBoardNumbers(newNumbers: newNumbers)
                self.score = newScore
                
                self.highScore = highScore < newScore ? newScore : highScore
                
                gameOverView.isHidden = !gameBoard.isOutOfMoves
                
                collectionView.reloadData()
            } catch GameBoardError.InvalidBoardNumbers {
                print("error")
            } catch let error {
                print(error)
            }
        }
    }
}

extension GameViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellAcross * cellAcross
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        
        let row = indexPath[1] / cellAcross
        let col = indexPath[1] % cellAcross
        
        if let gameCell = cell as? GameCell,
            let gameBoard = gameBoard {
            gameCell.cellText = gameBoard[row, col]
            
            gameCell.backgroundColor = UIColor.getCellColor(fromCellText: gameBoard[row, col] ?? "")
            
            return gameCell
        }
        
        return cell
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSideSize = (collectionView.bounds.width - ((CGFloat(cellAcross) - CGFloat(1)) * spaceBetweenCells)) / CGFloat(cellAcross)
        
        return CGSize(width: cellSideSize, height: cellSideSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return spaceBetweenCells
    }
}

