//
//  ViewController.swift
//  tic-tac-toe
//
//  Created by David Dunne on 02/07/2021.
//

import UIKit

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

enum GamePiece {
    case cross
    case circle
    case blank
}

func getResetBoard() -> [GamePiece] {
    return [GamePiece.blank, .blank, .blank, .blank, .blank, .blank, .blank, .blank, .blank]
}

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var board = getResetBoard()
    
    func resetBoard() {
        board = getResetBoard()
        label.text = "Crosses go first"
        label.isHidden = false
        for i in 1...9 {
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, for: UIControl.State())
        }
    }
    
    let winningCombinations = [
        [0,1,2],
        [3,4,5],
        [6,7,8],
        [0,3,6],
        [1,4,7],
        [2,5,8],
        [0,4,8],
        [2,4,6]
    ]
    var activePlayer = GamePiece.cross
    var gameIsActive = true
    
    
    func pieceIsPlayable(Position: Int) -> Bool {
        return board[Position] == GamePiece.blank
    }
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func action(_ sender: AnyObject) {
        
        if self.pieceIsPlayable(Position: sender.tag-1) && gameIsActive {
            label.isHidden = true
            placeGamePiece(PlayerPiece: activePlayer, Position: sender.tag-1)
            gameIsActive = checkForWinner()
        }
        
        func placeGamePiece(PlayerPiece: GamePiece, Position: Int) {
            board[Position] = PlayerPiece
            
            if (PlayerPiece == GamePiece.cross) {
                sender.setImage(UIImage(named:"Cross"), for: UIControl.State())
                activePlayer = GamePiece.circle
            }
            else {
                sender.setImage(UIImage(named:"Circle"), for: UIControl.State())
                activePlayer = GamePiece.cross
            }
        }
        
        func checkForWinner() -> Bool {
            for combination in winningCombinations {
                if (board[combination[0]] != GamePiece.blank && board[combination[0]] == board[combination[1]] && board[combination[1]] == board[combination[2]]) {
                    
                    if board[combination[0]] == GamePiece.cross {
                        label.text = "Crosses have won! 🎉"
                    }
                    
                    else {
                        label.text = "Circles have won! 🎉"
                    }
                    
                    playAgainButton.isHidden = false
                    label.isHidden = false
                    return false
                }
            }
            
            return checkForDraw()
        }
        
        func checkForDraw() -> Bool {
            for i in board {
                if i == GamePiece.blank {
                    return true
                }
            }
            label.text = "It was a draw 😑"
            label.isHidden = false
            playAgainButton.isHidden = false
            return false
        }
    }
    
    @IBOutlet weak var playAgainButton: UIButton!
    @IBAction func playAgain(_ sender: Any)
    {
        self.resetBoard()
        gameIsActive = true
        activePlayer = GamePiece.cross
        
        playAgainButton.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

