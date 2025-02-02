//
//  GameScene.swift
//  Sprite2
//  Created by Stefan Brandt on 02.02.25.

import SpriteKit

class GameScene: SKScene {
    
    let player = SKSpriteNode(color: .blue, size: CGSize(width: 40, height: 40))
    
    var pressedKeys = Set<UInt16>() // Speichert gedrückte Tasten
     
    override func didMove(to view: SKView) {
        // Hintergrundfarbe setzen
        self.backgroundColor = .black
        
        // Beispiel: Spieler hinzufügen
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height / 4)
        addChild(player)
        
        if let starField = SKEmitterNode(fileNamed: "MyParticle") {
            starField.position = CGPoint(x: self.size.width / 2, y: self.size.height)
            starField.advanceSimulationTime(10) // Startet sofort sichtbare Partikel
            starField.zPosition = -2 // Hintergrundebene
            addChild(starField)
        }
        
        // Linke Wand erstellen
                let leftWall = SKShapeNode(rectOf: CGSize(width: 10, height: self.size.height))
                leftWall.fillColor = .white
                leftWall.position = CGPoint(x: 15, y: self.size.height / 2)
                leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.frame.size)
                leftWall.physicsBody?.isDynamic = false // Wand bleibt statisch
                leftWall.physicsBody?.categoryBitMask = 2
                addChild(leftWall)
        
        // Rechte Wand erstellen
                let rightWall = SKShapeNode(rectOf: CGSize(width: 10, height: self.size.height))
                rightWall.fillColor = .white
                rightWall.position = CGPoint(x: self.size.width - 15, y: self.size.height / 2)
                rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.frame.size)
                rightWall.physicsBody?.isDynamic = false // Wand bleibt statisch
                rightWall.physicsBody?.categoryBitMask = 2
                addChild(rightWall)
        
        // Textknoten erstellen
                let label = SKLabelNode(text: "Erichs Game!")
                label.fontName = "Helvetica-Bold" // Schriftart
                label.fontSize = 36 // Schriftgröße
                label.fontColor = .white // Schriftfarbe
                label.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2) // Zentriert
                label.zPosition = -5 // Über dem Hintergrund anzeigen
                addChild(label) // Textknoten zur Szene hinzufügen
        
        // Animation erstellen
                let moveToCenter = SKAction.move(to: CGPoint(x: self.size.width / 2, y: self.size.height / 2), duration: 2.0) // Zur Mitte bewegen
                let scaleDown = SKAction.scale(to: 0.1, duration: 2.0) // Verkleinern auf 10% der Originalgröße
                let fadeOut = SKAction.fadeOut(withDuration: 1.0) // Langsam ausblenden
                let remove = SKAction.removeFromParent() // Aus der Szene entfernen
                
                // Parallel laufende Aktionen kombinieren
                let group = SKAction.group([moveToCenter, scaleDown])
                
                // Sequenz mit Ausblenden und Entfernen kombinieren
                let animationSequence = SKAction.sequence([group, fadeOut, remove])
                
                // Animation starten
                label.run(animationSequence)
        
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnObstacle),
                SKAction.wait(forDuration: 2.0)
            ])
        ))
        
    }

    override func keyDown(with event: NSEvent) {
            switch event.keyCode {
            case 123: // Links-Pfeil
                player.position.x -= 20
                if player.position.x < 30 { // Verhindert das Überqueren der linken Wand
                    player.position.x = 15
                }
            case 124: // Rechts-Pfeil
                player.position.x += 20
                if player.position.x > self.size.width - 30 { // Verhindert das Überqueren der rechten Wand
                    player.position.x = self.size.width - 15
                }
            default:
                break
            }
        }
    
    func spawnObstacle() {
        let obstacle = SKShapeNode(circleOfRadius: 20)
        obstacle.fillColor = .red
        obstacle.position = CGPoint(x: CGFloat.random(in: frame.minX...frame.maxX), y: frame.maxY)
        
        addChild(obstacle)
        
        let moveAction = SKAction.moveTo(y: frame.minY - 50, duration: 4.0)
        let removeAction = SKAction.removeFromParent()
        obstacle.run(SKAction.sequence([moveAction, removeAction]))
    }
    
}




