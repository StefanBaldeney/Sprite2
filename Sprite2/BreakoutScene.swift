//
//  BreakoutScene.swift
//  Sprite2
//
//  Created by Stefan Brandt on 03.02.25.
//

import Foundation
import SpriteKit

class BreakoutScene: SKScene {
    
    var paddle: SKSpriteNode!
    var ball: SKSpriteNode!
    var bricks: [SKSpriteNode] = []

    override func didMove(to view: SKView) {
        // Hintergrundfarbe
        backgroundColor = .black

        // Schläger (Paddle)
        paddle = SKSpriteNode(color: .white, size: CGSize(width: 100, height: 20))
        paddle.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)

        // Ball
        ball = SKSpriteNode(color: .red, size: CGSize(width: 15, height: 15))
        ball.position = CGPoint(x: size.width / 2, y: size.height / 2)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.contactTestBitMask = 2 | 4 // Paddle und Bricks
        addChild(ball)

        // Ball starten
        ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: -10))

        // Wände hinzufügen
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        // Blöcke (Bricks) hinzufügen
        createBricks()
    }

    func createBricks() {
        let rows = 5
        let columns = 8
        let brickWidth = size.width / CGFloat(columns)
        let brickHeight: CGFloat = 20

        for row in 0..<rows {
            for column in 0..<columns {
                let brick = SKSpriteNode(color: .blue, size: CGSize(width: brickWidth - 5, height: brickHeight - 5))
                brick.position = CGPoint(
                    x: CGFloat(column) * brickWidth + brickWidth / 2,
                    y: size.height - CGFloat(row + 1) * (brickHeight + 5)
                )
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.isDynamic = false
                brick.physicsBody?.categoryBitMask = 4 // Brick-Kategorie
                bricks.append(brick)
                addChild(brick)
            }
        }
    }
}

