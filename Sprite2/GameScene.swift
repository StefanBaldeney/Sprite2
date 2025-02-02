//
//  GameScene.swift
//  Sprite2
//  Created by Stefan Brandt on 02.02.25.

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    var obstacles: [SKNode] = [] // Speichert alle aktiven Hindernisse

    var lives: Int = 3
    var score: Int = 0
    var hiScore: Int = 0
    
    let player = SKSpriteNode(imageNamed: "AstroChase4") // Name der Bilddatei
    
    var pressedKeys = Set<UInt16>() // Speichert gedrückte Tasten
     
    let scoreLabel = SKLabelNode(text: "Score: 0")
    let highScoreLabel = SKLabelNode(text: "Highscore: 0")
    
    func updateHighScore(currentScore: Int) {
        if currentScore > hiScore {
            hiScore = currentScore
            print("Neuer Highscore: \(hiScore)")
        }
    }

    
    override func didMove(to view: SKView) {
        // Hintergrundfarbe setzen
        self.backgroundColor = .black
        
        physicsWorld.contactDelegate = self // Kontaktdelegat setzen
        
        // Beispiel: Spieler hinzufügen
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height / 4)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size) // Rechteckiger Physik-Körper
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.categoryBitMask = 1 // Kategorie des Spielers
        player.physicsBody?.contactTestBitMask = 2 // Testet Kontakt mit Hindernissen
        player.physicsBody?.collisionBitMask = 0 // Keine physikalische Kollision
        player.physicsBody?.affectedByGravity = false // Keine Schwerkraft
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
        
        // Lives
        let lives = SKLabelNode(text: "Leben: ")
        lives.fontName = "Helvetica-Bold" // Schriftart
        lives.fontSize = 16 // Schriftgröße
        lives.fontColor = .yellow // Schriftfarbe
        lives.position = CGPoint(x: 25, y: self.size.height-50)
        lives.zPosition = -5
        lives.horizontalAlignmentMode = .left

        addChild(lives) // Textknoten zur Szene hinzufügen
        
        // HighScore
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.fontSize = 16
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontColor = .gray
        scoreLabel.position = CGPoint(x: 25, y: self.size.height-70) // Beispielposition
        addChild(scoreLabel)
        
        // HighScore
        highScoreLabel.fontName = "Helvetica-Bold"
        highScoreLabel.fontSize = 16
        highScoreLabel.horizontalAlignmentMode = .left
        highScoreLabel.fontColor = .yellow
        highScoreLabel.position = CGPoint(x: 25, y: self.size.height-90) // Beispielposition
        addChild(highScoreLabel)
        
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
                SKAction.wait(forDuration: 0.3)
            ])
        ))
        
    }

    func updateHighScoreLabel() {
        highScoreLabel.text = "Highscore: \(hiScore)"
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
            let bodyA = contact.bodyA.node // Erstes Objekt der Kollision
            let bodyB = contact.bodyB.node // Zweites Objekt der Kollision

            if let playerNode = bodyA as? SKSpriteNode, let obstacleNode = bodyB as? SKSpriteNode {
                print("Kollision zwischen Spieler und Hindernis erkannt!")
                handleCollision(player: playerNode, obstacle: obstacleNode)
            }
        }

        func handleCollision(player: SKSpriteNode, obstacle: SKSpriteNode) {
            // Logik für die Kollision (z. B. Spiel beenden oder Punkt abziehen)
            print("Spieler hat ein Hindernis getroffen!")
        }
    
    override func keyUp(with event: NSEvent) {
        pressedKeys.remove(event.keyCode) // Taste als losgelassen markieren
    }
    
    override func keyDown(with event: NSEvent) {
        pressedKeys.insert(event.keyCode) // Taste als gedrückt markieren
    }
    
    override func update(_ currentTime: TimeInterval) {
        let moveSpeed: CGFloat = 3.0
           
           if pressedKeys.contains(123) { // Links-Pfeil
               player.position.x -= moveSpeed
               if player.position.x < 40 { // Verhindert das Überqueren der linken Wand
                   player.position.x = 40
               }
           }
           if pressedKeys.contains(124) { // Rechts-Pfeil
               player.position.x += moveSpeed
               if player.position.x > self.size.width - 40 { // Verhindert das Überqueren der rechten Wand
                   player.position.x = self.size.width - 40
               }
           }
    }
    
    
//    func spawnObstacle() {
//
//        let obstacle = SKSpriteNode(color: .red, size: CGSize(width: 40, height: 40))
//        obstacle.position = CGPoint(x: CGFloat.random(in: frame.minX+60...frame.maxX-60), y: frame.maxY)
//        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size) // Rechteckiger Physik-Körper
//        obstacle.physicsBody?.categoryBitMask = 2 // Kategorie des Hindernisses
//        obstacle.physicsBody?.contactTestBitMask = 1 // Testet Kontakt mit dem Spieler
//        obstacle.physicsBody?.collisionBitMask = 0 // Keine physikalische Kollision
//        obstacle.physicsBody?.isDynamic = false // Hindernis bleibt statisch
//        addChild(obstacle)
//        
//        let moveAction = SKAction.moveTo(y: frame.minY - 50, duration: 3.0)
//        let removeAction = SKAction.removeFromParent()
//        obstacle.run(SKAction.sequence([moveAction, removeAction]))
//    }
    
    func spawnObstacle() {
        //let obstacle = SKShapeNode(circleOfRadius: 20) // Beispiel: Roter Kreis
        //let obstacle = SKSpriteNode(color: .red, size: CGSize(width: 40, height: 40))
        let obstacle = SKSpriteNode(imageNamed: "asteroid7")
        // obstacle.fillColor = .red
        obstacle.position = CGPoint(x: CGFloat.random(in: frame.minX+80...frame.maxX-80), y: frame.maxY+80)
        
        // Physik-Körper hinzufügen, falls benötigt
        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        obstacle.physicsBody?.isDynamic = false // true?
        obstacle.physicsBody?.categoryBitMask = 2
        obstacle.physicsBody?.contactTestBitMask = 1
        obstacle.physicsBody?.collisionBitMask = 0
        
        addChild(obstacle) // Hindernis zur Szene hinzufügen
        obstacles.append(obstacle) // Hindernis zum Array hinzufügen
        
        // Bewegung nach unten und Entfernen des Hindernisses
        let moveAction = SKAction.moveTo(y: frame.minY - 50, duration: 4.0)
        let removeAction = SKAction.run {
            self.obstacles.removeAll { $0 == obstacle } // Entfernt das Hindernis aus dem Array
            obstacle.removeFromParent() // Entfernt das Hindernis aus der Szene
            print("Hindernis entfernt. Aktive Hindernisse: \(self.obstacles.count)")
        }
        obstacle.run(SKAction.sequence([moveAction, removeAction]))
        
        print("Hindernis erzeugt. Aktive Hindernisse: \(obstacles.count)")
    }
    
}




