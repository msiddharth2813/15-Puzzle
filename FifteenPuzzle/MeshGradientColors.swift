//
//  MeshGradientColors.swift
//  FifteenPuzzle
//
//  Created by siddharth on 10/7/24.
//
import SwiftUI

struct MeshGradientColors {
    
    let color1: Color
    let color2: Color
    let color3: Color
    let color4: Color
    let color5: Color
    let color6: Color
    let color7: Color
    let color8: Color
    let color9: Color

    
    static var randomTheme = 0
    
    func gradientColors() -> [Color] { return [color1, color2, color3, color4, color5, color6, color7, color8, color9]
    }
    
    func playButtonColor() -> Color {
        color4.mix(with: color9, by: 0.1)
    }
    
    static var blueTheme = MeshGradientColors.init(color1: .blue, color2: .blue, color3: .blue, color4: .teal, color5: .teal, color6: .teal, color7: .green, color8: .green, color9: .green)
    
    static var purpleBlueTheme = MeshGradientColors.init(color1: .teal, color2: .teal, color3: .teal, color4: .cyan.mix(with: .indigo, by: 0.4), color5: .cyan.mix(with: .indigo, by: 0.4), color6: .cyan.mix(with: .indigo, by: 0.4), color7: .purple, color8: .purple, color9: .purple)
    
    static var greenRed = MeshGradientColors.init(color1: .mint.mix(with: .green, by: 0.1), color2: .mint.mix(with: .green, by: 0.1), color3: .mint.mix(with: .green, by: 0.1), color4: .cyan, color5: .cyan, color6: .cyan, color7: .blue.mix(with: .cyan, by: 0.7), color8: .blue.mix(with: .cyan, by: 0.7), color9: .blue.mix(with: .cyan, by: 0.7))
    
    static var yellowTheme = MeshGradientColors.init(color1: .yellow, color2: .yellow, color3: .yellow, color4: .orange, color5: .orange, color6: .orange, color7: .yellow.mix(with: .pink, by: 0.8), color8: .yellow.mix(with: .pink, by: 0.8), color9: .yellow.mix(with: .pink, by: 0.8))
    
    static var yellowGreenTheme = MeshGradientColors.init(color1: .mint.mix(with: .green, by: 0.2), color2: .mint.mix(with: .green, by: 0.2), color3: .mint.mix(with: .green, by: 0.2), color4: .green.mix(with: .white, by: 0.3), color5: .green.mix(with: .white, by: 0.3), color6: .green.mix(with: .white, by: 0.3), color7: .yellow, color8: .yellow, color9: .yellow)
    
    static var lightgreenTheme = MeshGradientColors.init(color1: .yellow.mix(with: .green, by: 0.2), color2: .yellow.mix(with: .green, by: 0.2), color3: .yellow.mix(with: .green, by: 0.2), color4: .yellow.mix(with: .green, by: 0.3), color5: .yellow.mix(with: .green, by: 0.3), color6: .yellow.mix(with: .green, by: 0.3), color7: .mint.mix(with: .green, by: 0.9), color8: .mint.mix(with: .green, by: 0.9), color9: .mint.mix(with: .green, by: 0.9))
    
    static var pinkTheme = MeshGradientColors.init(color1: .pink.mix(with: .yellow, by: 0.5), color2: .pink.mix(with: .yellow, by: 0.5), color3: .pink.mix(with: .yellow, by: 0.5), color4: .pink.mix(with: .orange, by: 0.2), color5: .pink.mix(with: .orange, by: 0.2), color6: .pink.mix(with: .orange, by: 0.2), color7: .purple.mix(with: .pink, by: 0.4), color8: .purple.mix(with: .pink, by: 0.4), color9: .purple.mix(with: .pink, by: 0.4))
    
    static var yellowOrange = MeshGradientColors.init(color1: .pink.mix(with: .yellow, by: 0.2), color2: .pink.mix(with: .yellow, by: 0.2), color3: .pink.mix(with: .yellow, by: 0.2), color4: .orange.mix(with: .yellow, by: 0.1), color5: .orange.mix(with: .yellow, by: 0.1), color6: .orange.mix(with: .yellow, by: 0.1), color7: .yellow.mix(with: .white, by: 0.1), color8: .yellow.mix(with: .white, by: 0.1), color9: .yellow.mix(with: .white, by: 0.1))
    
    static func randomGradient() -> MeshGradientColors {
        randomTheme += 1

        if MeshGradientColors.randomTheme == 1 {
            return .blueTheme
        } else if randomTheme == 2 {
            return .yellowTheme
        } else if randomTheme == 3 {
            return .yellowGreenTheme
        } else if randomTheme == 4 {
            return .lightgreenTheme
        } else if randomTheme == 5 {
            return .purpleBlueTheme
        } else if randomTheme == 6 {
            return .greenRed
        } else if randomTheme == 7 {
            return .pinkTheme
        } else if randomTheme == 8 {
            return .yellowOrange
       }
        else {
            randomTheme = 0
            return randomGradient()
        }
    }
}

