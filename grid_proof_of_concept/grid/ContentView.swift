//
//  ContentView.swift
//  grid
//
//  Created by siddharth on 9/8/24.
//

import SwiftUI

class GameEngine: ObservableObject {
    var fillRectanglesPosition: [Int: CGPoint] = [:]

    @Published
    var buttonGridPosition: [Int: CGPoint] = [:]
}

struct ContentView: View {
    @ObservedObject var engine = GameEngine()

    var body: some View {
        VStack {
            ZStack {
                ForEach(1...4, id: \.self) { button in
                    Rectangle()
                        .fill(.yellow)
                        .frame(width: 100, height: 100)
                        .position(self.engine.fillRectanglesPosition[button] ?? .zero)
                }
                ForEach(1...4, id: \.self) { button in
                    if button == 4 {
                        EmptyView()
                    } else {
                        Button {
                            
                        } label: {
                            Text("\(button)")
                                .frame(width: 100, height: 100)
                        }
                        .background(Color.green)
                        .position(self.engine.buttonGridPosition[button] ?? .zero)
                    }
                }
            }.frame(height: 400)
            
            HStack {
                Button("Move 2 Down") {
                    withAnimation {
                        let button2Pos = self.engine.buttonGridPosition[2]
                        self.engine.buttonGridPosition[2] = self.engine.buttonGridPosition[4]
                        self.engine.buttonGridPosition[4] = button2Pos
                    }
                }.buttonStyle(.borderedProminent)

                Button("Move 1 Right") {
                    withAnimation {
                        let button4Pos = self.engine.buttonGridPosition[4]
                        self.engine.buttonGridPosition[4] = self.engine.buttonGridPosition[1]
                        self.engine.buttonGridPosition[1] = button4Pos
                    }
                }.buttonStyle(.borderedProminent)
            }

        }.onAppear {
            self.engine.buttonGridPosition = [
                1: CGPoint(x: 100, y: 100),
                2: CGPoint(x: 220, y: 100),
                3: CGPoint(x: 100, y: 220),
                4: CGPoint(x: 220, y: 220)
            ]

            self.engine.fillRectanglesPosition = [
                1: CGPoint(x: 100, y: 100),
                2: CGPoint(x: 220, y: 100),
                3: CGPoint(x: 100, y: 220),
                4: CGPoint(x: 220, y: 220)
            ]

        }
    }
}

#Preview {
    ContentView()
}
