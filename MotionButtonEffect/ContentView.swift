//
//  ContentView.swift
//  Experiments
//
//  Created by Raul on 15.03.2023.
//

import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var x = 0.0
    @Published var y = 0.0
    
    init() {
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in

            guard let motion = data?.attitude else { return }
            self?.x = motion.roll
            self?.y = motion.pitch
        }
    }
}

struct ContentView: View {
    @StateObject private var motion = MotionManager()
    
    @State var translation: CGSize = .zero
    @State var isDragging = false

    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                translation = value.translation
                isDragging = true
            }
            .onEnded { value in
                withAnimation {
                    translation = .zero
                    isDragging = false
                }
            }
    }
    
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Image("pxfuel")
                    .resizable()
                    .offset(x: motion.x * 50, y: motion.y * 50)
                    .mask {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .frame(width: 250, height: 70)
                    }
                    .shadow(
                        color: Color(#colorLiteral(
                            red: 0.5725490196,
                            green: 0.5725490196,
                            blue: 0.6862745098,
                            alpha: 1)
                        ),
                        radius: 2, x: 0, y: 0
                    )
                    .rotation3DEffect(.degrees(motion.x * 5), axis: (x: 0, y: 1, z: 0))
                    .rotation3DEffect(.degrees(motion.y * 5), axis: (x: -1, y: 0, z: 0))
                    .gesture(drag)
            }
            
            Text("Join Waitlist")
                .font(.custom("Satoshi-Variable", size: 23))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(#colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 0.82)), Color(#colorLiteral(red: 0.5141947269, green: 0.5141947269, blue: 0.5141947269, alpha: 1))],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
