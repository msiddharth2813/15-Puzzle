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
    let color10: Color
    let color11: Color
    let color12: Color
    static var randomTheme = 0
    
    func gradientColors() -> [Color] { return [color1, color2, color3, color4, color5, color6, color7, color8, color9, color10, color11, color12]
    }
    
    func playButtonColor() -> Color {
        color4.mix(with: color12, by: 0.1)
    }
    
    static var blueTheme = MeshGradientColors.init(color1: .blue, color2: .blue, color3: .blue, color4: .cyan, color5: .cyan, color6: .cyan, color7: .green, color8: .green, color9: .green, color10: .mint, color11: .mint, color12: .mint)
    
    static var purpleBlueTheme = MeshGradientColors.init(color1: .teal, color2: .teal, color3: .teal, color4: .cyan, color5: .cyan, color6: .cyan, color7: .purple, color8: .purple, color9: .purple, color10: .indigo, color11: .indigo, color12: .indigo)
    
    static var greenRed = MeshGradientColors.init(color1: .orange, color2: .orange, color3: .orange, color4: .yellow, color5: .yellow, color6: .yellow, color7: .mint, color8: .mint, color9: .mint, color10: .mint, color11: .mint, color12: .mint)
    
    static var yellowTheme = MeshGradientColors.init(color1: .yellow, color2: .yellow, color3: .yellow, color4: .yellow, color5: .yellow, color6: .yellow, color7: .orange, color8: .orange, color9: .orange, color10: .red, color11: .red, color12: .red)
    
    static var yellowGreenTheme = MeshGradientColors.init(color1: .mint, color2: .mint, color3: .mint, color4: .green, color5: .green, color6: .green, color7: .yellow, color8: .yellow, color9: .yellow, color10: .orange, color11: .orange, color12: .orange)
    
    static var lightgreenTheme = MeshGradientColors.init(color1: .yellow.mix(with: .green, by: 0.5), color2: .yellow.mix(with: .green, by: 0.5), color3: .yellow.mix(with: .green, by: 0.5), color4: .green, color5: .green, color6: .green, color7: .mint.mix(with: .green, by: 0.5), color8: .mint.mix(with: .green, by: 0.5), color9: .mint.mix(with: .green, by: 0.5), color10: .green, color11: .green, color12: .green)
    
    static var pinkTheme = MeshGradientColors.init(color1: .pink.mix(with: .yellow, by: 0.5), color2: .pink.mix(with: .yellow, by: 0.5), color3: .pink.mix(with: .yellow, by: 0.5), color4: .pink.mix(with: .purple, by: 0.2), color5: .pink.mix(with: .purple, by: 0.2), color6: .pink.mix(with: .purple, by: 0.2), color7: .purple, color8: .purple, color9: .purple, color10: .indigo, color11: .indigo, color12: .indigo)
    
    static var yellowOrange = MeshGradientColors.init(color1: .yellow, color2: .yellow, color3: .yellow, color4: .orange, color5: .orange, color6: .orange, color7: .purple, color8: .purple, color9: .purple, color10: .pink, color11: .pink, color12: .pink)
    
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

