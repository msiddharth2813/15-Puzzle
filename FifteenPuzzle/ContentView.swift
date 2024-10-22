//
//  ContentView.swift
//  FifteenPuzzle
//
//  Created by siddharth on 8/25/24.
//

import SwiftUI
import AVKit
import AVFoundation

struct ContentView: View {

    let totalCellCount = 16
    let gridSpacing: CGFloat = 8

    @Environment(\.scenePhase) var scenePhase

    @State var startDate = Date.now
    @State var cellWidth: CGFloat = 0
    @State var affect = 0
    @State var scale: CGFloat = 1
    @State var currentTimerSecond = 0
    @State var showFirstImage = true
    @State var timerInString = ""
    @State var hidePlayButtonView = false
    @State var showingAlert = false
    @State var playStarted = false
    @State var currentTheme: MeshGradientColors = .randomGradient()
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var audioPlayer: AVAudioPlayer?

    @ObservedObject var gameEngine = GameEngine(size: CGSize.zero)
        
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                MeshGradient(width: 3, height: 3, points: [
                    .init(0, 0), .init(0.5, 0), .init(1, 0),
                    .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                    .init(0, 1), .init(0.5, 1), .init(1, 1)
                ], colors: currentTheme.gradientColors())
                .frame(width: proxy.size.width, height: proxy.size.height)
                
                VStack(spacing: 10) {
                    Text("15 Puzzle")
                        .font(.system(size: 60))
                        .monospaced()
                        .foregroundStyle(Color.black.opacity(0.7))
                    HStack {
                       Text("\(timerInString)")
                            .monospaced()
                            .font(.system(size: 42))
                            .onReceive(timer) { _ in
                                guard playStarted else {
                                    return
                                }
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
                                                guard playStarted else {
                                                    return
                                                }
                                                guard !hidePlayButtonView else {
                                                    return
                                                }
                                                // Cancel on pause
                                                showFirstImage.toggle()
                                                timer.upstream.connect().cancel()
                                                hidePlayButtonView.toggle()
                                                affect += 1
                                            }
                                    )
                                    .sensoryFeedback(.impact, trigger: affect)
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
                                                affect += 1
                                            }
                                    )
                                    .sensoryFeedback(.impact, trigger: affect)
                            }
                        }
                    }
                    ZStack {
                        ForEach(1...totalCellCount, id: \.self) { position in
                            Rectangle()
                                .fill(Color.black.opacity(0.1))
                                .cornerRadius(15)
                                .frame(width: cellWidth, height: cellWidth)
                                .position(gameEngine.fillRectanglePositions[position] ?? .zero)
                        }
                        ForEach(1...totalCellCount, id: \.self) { position in
                            let cell = position
                            if cell == 16 {
                                EmptyView()
                            } else {
                                ZStack{
                                    Button {
                                        print("Text tapped \(cell)")
                                        withAnimation() {
                                            guard playStarted else {
                                                return
                                            }
                                            guard !hidePlayButtonView else {
                                                return
                                            }
                                            let isButtonSwapped = gameEngine.buttonTapped(buttonNumber: cell)
                                            if isButtonSwapped == true {
                                                audioPlayer?.play()
                                            }
                                            let gameWon = gameEngine.gameFinished()
                                            if gameWon == true {
                                                showingAlert = true
                                                timer.upstream.connect().cancel()
                                            }
                                        }
                                        affect += 1
                                    }
                                    label: {
                                        Text("\(cell)")
                                            .font(.system(size: 35))
                                            .foregroundColor(hidePlayButtonView ? Color.white.opacity(0.0) : Color.black.opacity(0.8))
                                            .frame(width: cellWidth, height: cellWidth)
                                            .monospaced()
                                    }
                                    .alert("Puzzle Solved", isPresented: $showingAlert) {
                                        Button("Play Again😉", role: .cancel) {
                                            guard playStarted else {
                                                return
                                            }
                                            affect += 1
                                            currentTheme = MeshGradientColors.randomGradient()
                                            guard !hidePlayButtonView else {
                                                return
                                            }
                                            playStarted = false
                                            gameEngine.randomNumberGenerator()
                                            currentTimerSecond = 0
                                            let duration = Duration.seconds(currentTimerSecond)
                                            let format = duration.formatted(
                                                .time(pattern: .minuteSecond(padMinuteToLength: 2))
                                            )
                                            timerInString = format
                                        }
                                    }
                                    .background(Color.white.opacity(0.7))
                                    .animation(.easeOut, value: scale)
                                    .cornerRadius(15)
                                    .frame(width: cellWidth, height: cellWidth)
                                    .position(gameEngine.buttonGridPositions[position] ?? .zero)
                                    .sensoryFeedback(.impact, trigger: affect)
                                }
                            }
                        }
                        // Play button view
                        ZStack {
                            Rectangle()
                                .fill(currentTheme.playButtonColor())
                                .cornerRadius(15)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .frame(width: 120, height: 100)
                            Button {
                                playStarted.toggle()
                                affect += 1
                            }
                            label: {
                                Image(systemName: "play.fill")
                                    .foregroundStyle(Color.black.opacity(0.3))
                                    .font(.system(size: 60))
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .sensoryFeedback(.impact, trigger: affect)
                        .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
                        .opacity(playStarted ? 0 : 1)
                    }
                    .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
                    .onAppear {
                        let padding: CGFloat = (2 * 20) + (3 * gridSpacing)
                        cellWidth = (proxy.size.width - padding)/4
                        gameEngine.updateScreenSize(size: proxy.size)
                    }
                    .frame(width: proxy.size.width, height: 400)//gridProxy.size.height)
                    
                    Button {
                        guard playStarted else {
                            return
                        }
                        guard !hidePlayButtonView else {
                            return
                        }
                        affect += 1
                        currentTheme = MeshGradientColors.randomGradient()
                        playStarted = false
                        gameEngine.randomNumberGenerator()
                        currentTimerSecond = 0
                        let duration = Duration.seconds(currentTimerSecond)
                        let format = duration.formatted(
                            .time(pattern: .minuteSecond(padMinuteToLength: 2))
                        )
                        timerInString = format
                    } label: {
                        RoundedRectangle(cornerRadius: 15)
                        .fill(.white.opacity(0.7))
                        .frame(width: 200, height: 60)
                        .overlay {
                            HStack {
                                Image(systemName: "shuffle")
                                    .font(.system(size: 30))
                                    .foregroundStyle(Color.black)
                                    .monospaced()
                                Text("Shuffle")
                                    .font(.system(size: 26))
                                    .foregroundStyle(Color.black)
                                    .monospaced()
                            }.padding()
                        }
                    }
                    .sensoryFeedback(.impact, trigger: affect)
                    .padding(EdgeInsets(top: 70, leading: 0, bottom: 0, trailing: 0))
                } // Vstack
                .frame(width: proxy.size.width, height: proxy.size.height)
            } // Top Zstack
            .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
               print("Active")
                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            } else if newPhase == .inactive {
                print("Inactive")
                timer.upstream.connect().cancel()
            } else if newPhase == .background {
                print("Background")
                timer.upstream.connect().cancel()
            }
         }
        .onAppear {
                print("MANIII  proxy=\(proxy.size)")
                let duration = Duration.seconds(currentTimerSecond)
                let format = duration.formatted(
                    .time(pattern: .minuteSecond(padMinuteToLength: 2))
                )
                timerInString = format

                let url = Bundle.main.url(forResource: "sound_effect_1", withExtension: "wav")
                
                if let url {
                    do {
                        if audioPlayer == nil {
                            audioPlayer = try AVAudioPlayer(contentsOf: url)
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

//struct ContentView: View {
//
//    let totalCellCount = 16
//    let gridSpacing: CGFloat = 8
//
//    @Environment(\.scenePhase) var scenePhase
//
//    @State var startDate = Date.now
//    @State var cellWidth: CGFloat = 0
//    @State var affect = 0
//    @State var scale: CGFloat = 1
//    @State var currentTimerSecond = 0
//    @State var showFirstImage = true
//    @State var timerInString = ""
//    @State var hidePlayButtonView = false
//    @State var showingAlert = false
//    @State var playStarted = false
//    @State var currentTheme: MeshGradientColors = .randomGradient()
//    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    @State var audioPlayer: AVAudioPlayer?
//
//    @ObservedObject var gameEngine = GameEngine(size: CGSize.zero)
//        
//    var body: some View {
//        GeometryReader { proxy in
//        ZStack {
//            ForEach(1...totalCellCount, id: \.self) { position in
//                Rectangle()
//                    .fill(Color.black.opacity(0.1))
//                    .cornerRadius(15)
//                    .frame(width: cellWidth, height: cellWidth)
//                    .position(gameEngine.fillRectanglePositions[position] ?? .zero)
//            }
//        }
//        .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
//        .onAppear {
//            let padding: CGFloat = (2 * 20) + (3 * gridSpacing)
//            cellWidth = (proxy.size.width - padding)/4
//            gameEngine.updateScreenSize(size: proxy.size)
//        }
//        .frame(width: proxy.size.width, height: 400)
//        .onAppear {
//                print("MANIII  proxy=\(proxy.size)")
//                let duration = Duration.seconds(currentTimerSecond)
//                let format = duration.formatted(
//                    .time(pattern: .minuteSecond(padMinuteToLength: 2))
//                )
//                timerInString = format
//
//                let url = Bundle.main.url(forResource: "sound_effect_1", withExtension: "wav")
//                
//                if let url {
//                    do {
//                        if audioPlayer == nil {
//                            audioPlayer = try AVAudioPlayer(contentsOf: url)
//                        }
//                    } catch {
//                        
//                    }
//                }
//                
//            }
//            .frame(width: proxy.size.width, height: proxy.size.height)
//        }
//        .ignoresSafeArea()
//    }
//}
//
//
