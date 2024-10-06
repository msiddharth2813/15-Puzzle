//
//  GameEngine.swift
//  FifteenPuzzle
//
//  Created by siddharth on 9/3/24.
//
import SwiftUI

class GameEngine: ObservableObject {
    
    let gridSpacing: CGFloat = 8
    
    var numbers = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
    
    let padding: CGFloat = 20
            
    @Published var locationMapping = [Int : CGPoint]()
    
    @Published var buttonGridLocationMapping = [Int : CGPoint]()

    var buttonGridMap = [Int: Int]()
    var buttonGridPostionEmpty = 1
    
    init(size: CGSize) {
        updatePositionsMapping(size: size)
    }
    
    func randomNumberGenerator() {
        numbers.shuffle()
        for position in 1...16 {
            buttonGridMap[position] = numbers[position - 1]
            if numbers[position - 1] == 16 {
                buttonGridPostionEmpty = position
            }
            buttonGridLocationMapping[numbers[position - 1]] = locationMapping[position]
        }
        print("buttonGridLocationMapping\(buttonGridLocationMapping)")
        print(("buttongridmap\(buttonGridMap)"))
        print(("buttonGridPostionEmpty\(buttonGridPostionEmpty)"))
    }

   
    func gameFinished() -> Bool {
        if buttonGridMap[1] == 1 && buttonGridMap[2] == 2 && buttonGridMap[3] == 3 && buttonGridMap[4] == 4 &&
            buttonGridMap[5] == 5 && buttonGridMap[6] == 6 && buttonGridMap[7] == 7 && buttonGridMap[8] == 8 &&
            buttonGridMap[9] == 9 && buttonGridMap[10] == 10 && buttonGridMap[11] == 11 && buttonGridMap[12] == 12 &&
            buttonGridMap[13] == 13 && buttonGridMap[14] == 14 && buttonGridMap[15] == 15 && buttonGridMap[16] == 16
        {
            return true
        }
        return true
    }
    
    func updateScreenSize(size: CGSize) {
        updatePositionsMapping(size: size)
        randomNumberGenerator()
    }
    
    func buttonTapped(buttonNumber: Int) -> Bool {
        print("buttonGridMap \(buttonGridMap)")

        var buttonGridPostion = 1
        
        for (key, value) in buttonGridMap {
            if value == buttonNumber {
                buttonGridPostion = key
                print("key Match = \(key)")
                break
            }
        }
        print("buttonGridPostion \(buttonGridPostion)")
        
        print("buttonGridPostionEmpty \(buttonGridPostionEmpty)")
        
        if buttonNumber < 0 || buttonNumber > 16 {
            return false
        }
        
        
        
        // im checking where button can move
        print("buttonGridPostion\(buttonGridPostion)")
        if buttonGridPostion + 1 == buttonGridPostionEmpty || buttonGridPostion - 1 == buttonGridPostionEmpty ||
            buttonGridPostion + 4 == buttonGridPostionEmpty || buttonGridPostion - 4 == buttonGridPostionEmpty
        {
            print("empty cell around")
            
            let buttonPosition = buttonGridLocationMapping[buttonNumber]
            buttonGridLocationMapping[buttonNumber] = buttonGridLocationMapping[16] ?? .zero
            buttonGridLocationMapping[16] = buttonPosition
            
            // Swap the button position in gridmap
            let gridPos = buttonGridMap[buttonGridPostion]
            buttonGridMap[buttonGridPostion] = 16
            buttonGridMap[buttonGridPostionEmpty] = gridPos
            
            buttonGridPostionEmpty = buttonGridPostion
            
            return true
        }
        
        print("currentEmptyPos \(buttonGridPostionEmpty)")
        print("buttonGridMap \(buttonGridMap)")
        
        print("game finished\(gameFinished())")
        
//        if buttonGridPostion + 8 == buttonGridPostionEmpty || buttonGridPostion + 12 == buttonGridPostionEmpty || buttonGridPostion + 2 == buttonGridPostionEmpty || buttonGridPostion + 3 == buttonGridPostionEmpty || buttonGridPostion - 8 == buttonGridPostionEmpty || buttonGridPostion - 12 == buttonGridPostionEmpty || buttonGridPostion - 2 == buttonGridPostionEmpty || buttonGridPostion - 3 == buttonGridPostionEmpty{
//            
//            print("emptyPOS\(buttonGridPostionEmpty)")
//            
//            let buttonPosition = buttonGridLocationMapping[buttonNumber]
//            buttonGridLocationMapping[buttonNumber] = buttonGridLocationMapping[16] ?? .zero
//            buttonGridLocationMapping[16] = buttonPosition
//            
//            // Swap the button position in gridmap
//            let gridPos = buttonGridMap[buttonGridPostion]
//            buttonGridMap[buttonGridPostion] = 16
//            buttonGridMap[buttonGridPostionEmpty] = gridPos
//            
//            
//            buttonGridPostionEmpty = buttonGridPostion
//            
//        }
        return false
    }
    
    
    func updatePositionsMapping(size: CGSize) {
        let buttonWidth = (size.width - (2 * padding + 3 * gridSpacing)) / 4.0
        print("MANIII buttonWidth=\(buttonWidth)")
        print("MANIII size=\(size)")
        
        let gridheight = 4 * buttonWidth + 3 * gridSpacing
        
        print("MANIII gridheight=\(gridheight)")
        
        var startX = padding + buttonWidth / 2.0
        var startY: CGFloat = (size.height - gridheight) / 2.0
        print("MANIII startY=\(startY)")
        locationMapping[1] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        locationMapping[2] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        locationMapping[3] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        locationMapping[4] = CGPoint(x: startX, y: startY)
        
        startX = padding + buttonWidth / 2.0
        startY = startY + buttonWidth + gridSpacing
        locationMapping[5] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        locationMapping[6] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        locationMapping[7] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        locationMapping[8] = CGPoint(x: startX, y: startY)
        
        startX = padding + buttonWidth / 2.0
        startY = startY + buttonWidth + gridSpacing
        locationMapping[9] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        locationMapping[10] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        locationMapping[11] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        locationMapping[12] = CGPoint(x: startX, y: startY)
        
        startX = padding + buttonWidth / 2.0
        startY = startY + buttonWidth + gridSpacing
        locationMapping[13] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        locationMapping[14] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        locationMapping[15] = CGPoint(x: startX, y: startY)
        
        startX = startX + buttonWidth + gridSpacing
        locationMapping[16] = CGPoint(x: startX, y: startY)
        
        print("locationMapping\(locationMapping)")                
    }
}
