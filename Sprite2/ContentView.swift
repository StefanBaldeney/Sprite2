//  ContentView.swift
//  Sprite2
//  Created by Stefan Brandt on 02.02.25.

import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
            
        GeometryReader { geometry in
            let scene = GameScene(size: CGSize(width: geometry.size.width, height: geometry.size.height))

            // todo ScaleMode
            SpriteView(scene: scene)
                    .ignoresSafeArea()
            }
        }
}

#Preview {
    ContentView()
}
