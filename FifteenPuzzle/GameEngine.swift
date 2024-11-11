//
//  GameEngine.swift
//  FifteenPuzzle
//
//  Created by siddharth on 9/3/24.
//
import SwiftUI

class GameEngine: ObservableObject {
    
    let gridSpacing: CGFloat = 8
    
    let padding: CGFloat = 20

    var gridNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
    
    var fillRectanglePositions = [Int : CGPoint]()
    
    @Published 
    var buttonGridPositions = [Int : CGPoint]()

    var buttonGridMap = [Int: Int]()
    
    var emptyButtonGridPostion = 1
    
    let buttonRowMapping = [
        1: [2, 3, 4],
        2: [1, 3, 4],
        3: [1, 2, 4],
        4: [1, 2, 3],
        
        5: [6, 7, 8],
        6: [5, 7, 8],
        7: [5, 6, 8],
        8: [5, 6, 7],
        
        9: [10, 11, 12],
        10: [9, 11, 12],
        11: [9, 10, 12],
        12: [11, 9, 10],
        
        13: [14, 15, 16],
        14: [13, 15, 16],
        15: [14, 13, 16],
        16: [14, 15, 13],
    ]
    
    let buttonColumnMapping = [
        1: [5, 9, 13],
        2: [6, 10, 14],
        3: [11, 7, 15],
        4: [8, 12, 16],
        
        5: [1, 9, 13],
        6: [10, 2, 14],
        7: [3, 11, 15],
        8: [4, 12, 16],
        
        9: [13, 1, 5],
        10: [14, 6, 2],
        11: [15, 3, 7],
        12: [16, 8, 4],
        
        13: [9, 5, 1],
        14: [10, 2, 6],
        15: [11, 7, 3],
        16: [12, 8, 4],
    ]
    
    
    init(size: CGSize) {
        updatePositionsMapping(size: size)
    }
    
    func randomNumberGenerator() {
        gridNumbers.shuffle()
        for position in 1...16 {
            buttonGridMap[position] = gridNumbers[position - 1]
            if gridNumbers[position - 1] == 16 {
                emptyButtonGridPostion = position
            }
            buttonGridPositions[gridNumbers[position - 1]] = fillRectanglePositions[position]
        }
    }

   
    func gameFinished() -> Bool {
        if buttonGridMap[1] == 1 && buttonGridMap[2] == 2 && buttonGridMap[3] == 3 && buttonGridMap[4] == 4 &&
            buttonGridMap[5] == 5 && buttonGridMap[6] == 6 && buttonGridMap[7] == 7 && buttonGridMap[8] == 8 &&
            buttonGridMap[9] == 9 && buttonGridMap[10] == 10 && buttonGridMap[11] == 11 && buttonGridMap[12] == 12 &&
            buttonGridMap[13] == 13 && buttonGridMap[14] == 14 && buttonGridMap[15] == 15 && buttonGridMap[16] == 16
        {
            return true
        }
        return false
    }
    
    func updateScreenSize(size: CGSize) {
        updatePositionsMapping(size: size)
        randomNumberGenerator()
    }
    
    func buttonTapped(buttonNumber: Int) -> Bool {
        var buttonGridPostion = 1
        
        for (key, value) in buttonGridMap {
            if value == buttonNumber {
                buttonGridPostion = key
                break
            }
        }
        
        if buttonNumber < 0 || buttonNumber > 16 {
            return false
        }
        
        let rows = buttonRowMapping[buttonGridPostion] ?? []
        let columns = buttonColumnMapping[buttonGridPostion] ?? []
        var buttonPositionsToMove = [Int]()

        if rows.contains(emptyButtonGridPostion) {
        // Button tapped position is in same row as empty button position
            if emptyButtonGridPostion < buttonGridPostion {
                for index in stride(from: emptyButtonGridPostion + 1, through: buttonGridPostion, by: 1) {
                    buttonPositionsToMove.append(index)
                }
            } else {
                for index in stride(from: emptyButtonGridPostion - 1, through: buttonGridPostion, by: -1) {
                    buttonPositionsToMove.append(index)
                }
            }
        } else if columns.contains(emptyButtonGridPostion) {
            // Button tapped position is in same column as empty button position
            if emptyButtonGridPostion < buttonGridPostion {
                for index in stride(from: emptyButtonGridPostion, through: buttonGridPostion, by: 4) {
                    buttonPositionsToMove.append(index)
                }
            } else {
                for index in stride(from: emptyButtonGridPostion, through: buttonGridPostion, by: -4) {
                    buttonPositionsToMove.append(index)
                }
            }
        }
        
        print("buttonPositionsToMove = \(buttonPositionsToMove)")
        
        if !buttonPositionsToMove.isEmpty {
            for indexToMove in buttonPositionsToMove {
                if let buttonNumber = buttonGridMap[indexToMove] {
                    buttonSwap(buttonNumber: buttonNumber)
                }
            }
            return true
        } else {
            // No swap
            return false
        }
    }
    
    func buttonSwap(buttonNumber: Int) {
        
        var buttonGridPostion = 1
        
        for (key, value) in buttonGridMap {
            if value == buttonNumber {
                buttonGridPostion = key
                break
            }
        }

        let buttonPosition = buttonGridPositions[buttonNumber]
        buttonGridPositions[buttonNumber] = buttonGridPositions[16] ?? .zero
        buttonGridPositions[16] = buttonPosition
        
        // Swap the button position in gridmap
        let gridPos = buttonGridMap[buttonGridPostion]
        buttonGridMap[buttonGridPostion] = 16
        buttonGridMap[emptyButtonGridPostion] = gridPos
        
        emptyButtonGridPostion = buttonGridPostion
    }
    
    func updatePositionsMapping(size: CGSize) {
        let buttonWidth = (size.width - (2 * padding + 3 * gridSpacing)) / 4.0
        let gridheight = 4 * buttonWidth + 3 * gridSpacing
        
        var startX = padding + buttonWidth / 2.0
        var startY: CGFloat = 50 //padding top

        fillRectanglePositions[1] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        fillRectanglePositions[2] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        fillRectanglePositions[3] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        fillRectanglePositions[4] = CGPoint(x: startX, y: startY)
        
        startX = padding + buttonWidth / 2.0
        startY = startY + buttonWidth + gridSpacing
        fillRectanglePositions[5] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        fillRectanglePositions[6] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        fillRectanglePositions[7] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        fillRectanglePositions[8] = CGPoint(x: startX, y: startY)
        
        startX = padding + buttonWidth / 2.0
        startY = startY + buttonWidth + gridSpacing
        fillRectanglePositions[9] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        fillRectanglePositions[10] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        fillRectanglePositions[11] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        fillRectanglePositions[12] = CGPoint(x: startX, y: startY)
        
        startX = padding + buttonWidth / 2.0
        startY = startY + buttonWidth + gridSpacing
        fillRectanglePositions[13] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        fillRectanglePositions[14] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        fillRectanglePositions[15] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        fillRectanglePositions[16] = CGPoint(x: startX, y: startY)        
    }
}
