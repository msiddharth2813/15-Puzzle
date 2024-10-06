//
//  ContentView.swift
//  FifteenPuzzle
//
//  Created by siddharth on 8/25/24.
//

import SwiftUI
import AVKit
import AVFoundation

var player: AVAudioPlayer!

struct ContentView: View {
    @State var startDate = Date.now
    var futureDate = Date.now.addingTimeInterval(3000)
    let totalCellCount = 16
    let gridSpacing: CGFloat = 8
    @State var cellWidth: CGFloat = 50
    @State var affect = 0
    @State var scale:CGFloat = 1
    @State var currentTimerSecond = 0
    @State var showFirstImage = true
    @State var timerInString = ""
    @State var hidePlayButtonView = false
    @State private var showingAlert = false

    
    @ObservedObject var gameEngine = GameEngine(size: CGSize.zero)
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                MeshGradient(width: 3, height: 3, points: [
                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                    .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                    .init(0, 1), .init(0.5, 1), .init(1, 1)
                ], colors: [
                    .blue, .blue, .blue,
                    .teal, .teal, .teal,
                    .mint, .mint, .mint,
                    .cyan, .cyan, .cyan
                ]).frame(width: proxy.size.width, height: proxy.size.height)
                
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 20) {
                        Spacer()
                        Text("15 Puzzle")
                            .font(.system(size: 55))
                            .monospaced()
                            .foregroundStyle(Color.white.opacity(0.3))
                        HStack {
                           Text("\(timerInString)")
                                .onReceive(timer) { _ in
                                    currentTimerSecond += 1
                                    let duration = Duration.seconds(currentTimerSecond)
                                    let format = duration.formatted(
                                        .time(pattern: .minuteSecond(padMinuteToLength: 2))
                                    )
                                    timerInString = format
                                }
                                .font(.system(size: 40))
                            Group {
                                if showFirstImage {
                                    Image(systemName: "pause.fill")
                                        .font(.system(size: 40))
                                        .gesture(
                                            TapGesture()
                                                .onEnded { _ in
                                                    // Cancel on pause
                                                    showFirstImage.toggle()
                                                    timer.upstream.connect().cancel()
                                                    hidePlayButtonView.toggle()
                                                }
                                        )
                                }
                                else {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 40))
                                        .gesture(
                                            TapGesture()
                                                .onEnded { _ in
                                                    // Restart on continue
                                                    showFirstImage.toggle()
                                                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                                                    hidePlayButtonView.toggle()
                                                }
                                        )
                                }
                            }
                        }
                    }
                    .frame(width: proxy.size.width,height: proxy.size.height * 0.20, alignment: .center)
                    
                    GeometryReader { gridProxy in
                        ZStack {
                            ForEach(1...totalCellCount, id: \.self) { position in
                                Rectangle()
                                    .fill(Color.black.opacity(0.1))
                                    .cornerRadius(15)
                                    .frame(width: cellWidth, height: cellWidth)
                                    .position(gameEngine.locationMapping[position] ?? .zero)
                            }
                            ForEach(1...totalCellCount, id: \.self) { position in
                                let cell = position// gameEngine.numbers[position - 1]
                                if cell == 16 {
                                    EmptyView()
                                } else {
                                    ZStack{
                                        Button {
                                            print("Text tapped \(cell)")
                                            withAnimation() {
                                                guard !hidePlayButtonView else {
                                                    return
                                                }
                                                var isButtonSwapped = gameEngine.buttonTapped(buttonNumber: cell)
                                                if isButtonSwapped == true {
                                                    player?.play()
                                                }
                                                var gameWon = gameEngine.gameFinished()
                                                if gameWon == true {
                                                    showingAlert = true
                                                    timer.upstream.connect().cancel()
                                                }
                                            }
                                            affect += 1
                                        }
                                        label: {
                                            Text("\(cell)")
                                                .font(.largeTitle)
                                                .foregroundColor(hidePlayButtonView ? Color.white.opacity(0.0) : Color.black.opacity(0.7))
                                                .frame(width: cellWidth, height: cellWidth)
                                        }
                                        .alert("Game Won", isPresented: $showingAlert) {
                                           Button("OK", role: .cancel) { }
                                        }
                                        .background(Color.white.opacity(0.7))
                                        .animation(.easeOut, value: scale)
                                        .cornerRadius(15)
                                        .frame(width: cellWidth, height: cellWidth)
                                        .position(gameEngine.buttonGridLocationMapping[position] ?? .zero)
                                        .sensoryFeedback(.impact, trigger: affect)
                                    }
                                }
                            }
                            
                            // Play button view
//                            Rectangle()
//                                .fill(Color.black.opacity(0.1))
//                                .cornerRadius(15)
//                                
                            
                        } .onAppear {
                            print("MANIII  gridProxy=\(gridProxy.size)")
                            let padding: CGFloat = (2 * 20) + (3 * gridSpacing)
                            cellWidth = (gridProxy.size.width - padding)/4
                            print("MANII cellWidth = \(cellWidth)")
                            gameEngine.updateScreenSize(size: gridProxy.size)
                        }
                        .frame(width: proxy.size.width, height: gridProxy.size.height)
                    }
                    .frame(width: proxy.size.width)
                    VStack {
                        Button {
                            guard !hidePlayButtonView else {
                                return
                            }
                            gameEngine.randomNumberGenerator()
                            currentTimerSecond = 0
                        } label: {
                            RoundedRectangle(cornerRadius: 15)
                            .fill(.white.opacity(0.3))
                            .frame(width: 150, height: 60)
                            .overlay {
                                Text("Shuffle")
                                    .font(.system(size: 30))
                                    .foregroundStyle(Color.black)
                            }
                        }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height * 0.20)
                    Spacer()
                } // Vstack
                .frame(width: proxy.size.width, height: proxy.size.height)
                
            } // Zstack
            .onAppear {
                print("MANIII  proxy=\(proxy.size)")
                let url = Bundle.main.url(forResource: "sound_effect_1", withExtension: "wav")
                
                if let url {
                    do {
                        if player == nil {
                            player = try AVAudioPlayer(contentsOf: url)
                        }
                    } catch {
                        
                    }
                }
                
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
