//  GameScene.swift
//  Sprite2
//  Created by Stefan Brandt on 02.02.25.
//  notes: xattr -c /Users/StefanBrandt/Downloads/ship2.png

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    var obstacles: [SKNode] = [] // Speichert alle aktiven Hindernisse

    var lives: Int = 3
    var score: Int = 0
    var hiScore: Int = 0
    var level: Int = 1
    var obstacleSpeed: Double = 4
    
    var backgroundMusic: SKAudioNode?
    
    let player = SKSpriteNode(imageNamed: "ship8") //
    let boost = SKSpriteNode(imageNamed: "Boost8") // Boost ohne Kollisionserkennung
        
    var pressedKeys = Set<UInt16>() // Speichert gedrückte Tasten
     
    let scoreLabel = SKLabelNode(text: "Score: 0")
    let highScoreLabel = SKLabelNode(text: "Highscore: 0")
    let livesLabel = SKLabelNode(text: "Lives: 3")
    let levelLabel = SKLabelNode(text: "Level: 1")
    
    func updateHighScore(currentScore: Int) {
        if currentScore > hiScore {
            hiScore = currentScore
            UserDefaults.standard.set(hiScore, forKey: "HighScore")
            updateHighScoreLabel()
        }
    }
    
    func levelUp() {
        level += 1
        updateLevelLabel()
        
        if level == 2
        {
            if let scene = GameScene(fileNamed: "GameScene") {
                // Szene skalieren, um die Bildschirmgröße zu nutzen
                scene.scaleMode = .aspectFill

                // Szene dem SKView hinzufügen
                if let view = self.view as? SKView {
                    view.presentScene(scene)
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }

        }
        else{
            lives += 1
            obstacleSpeed *= 0.8
            
            if obstacleSpeed < 1 {obstacleSpeed = 1}
           
        }
                        
        // Erhöhe die Größe des Sprites proportional zum Level
        // let newSize = CGSize(width: sprite.size.width * 1.2, height: sprite.size.height * 1.2)
        // let resizeAction = SKAction.resize(toWidth: newSize.width, height: newSize.height, duration: 0.5)
        // sprite.run(resizeAction)
    }
    
    override func didMove(to view: SKView) {
        
        if let savedHighScore = UserDefaults.standard.value(forKey: "HighScore") as? Int {
            hiScore = savedHighScore
            updateHighScoreLabel()
        }
        
        if let musicURL = Bundle.main.url(forResource: "Flightmare", withExtension: "mp3") {
                    backgroundMusic = SKAudioNode(url: musicURL)
                    // addChild(backgroundMusic!) // Musik zur Szene hinzufügen
        }
                
        self.backgroundColor = .black
        
        physicsWorld.contactDelegate = self // Kontaktdelegat setzen
        
        // Beispiel: Spieler hinzufügen
        player.size = CGSize(width: 40, height: 80)
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height / 4)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size) // Rechteckiger Physik-Körper
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.categoryBitMask = 1 // Kategorie des Spielers
        player.physicsBody?.contactTestBitMask = 2 // Testet Kontakt mit Hindernissen
        player.physicsBody?.collisionBitMask = 0 // Keine physikalische Kollision
        player.physicsBody?.affectedByGravity = false // Keine Schwerkraft
        addChild(player)
        
        // Boost
        boost.size = CGSize(width: 10, height: 20)
        boost.position = CGPoint(x: player.position.x, y: player.position.y-40 )
        addChild(boost)
        
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
        
        // Level
        levelLabel.fontName = "Helvetica-Bold" // Schriftart
        levelLabel.fontSize = 16 // Schriftgröße
        levelLabel.fontColor = .yellow // Schriftfarbe
        levelLabel.position = CGPoint(x: 25, y: self.size.height-35)
        levelLabel.zPosition = -5
        levelLabel.horizontalAlignmentMode = .left
        addChild(levelLabel)
        // Lives
        //let lives = SKLabelNode(text: "Leben: ")
        livesLabel.fontName = "Helvetica-Bold" // Schriftart
        livesLabel.fontSize = 16 // Schriftgröße
        livesLabel.fontColor = .yellow // Schriftfarbe
        livesLabel.position = CGPoint(x: 25, y: self.size.height-55)
        livesLabel.zPosition = -5
        livesLabel.horizontalAlignmentMode = .left

        addChild(livesLabel) // Textknoten zur Szene hinzufügen
        
        // Score
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.fontSize = 16
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontColor = .gray
        scoreLabel.position = CGPoint(x: 25, y: self.size.height-75) // Beispielposition
        addChild(scoreLabel)
        
        // HighScore
        highScoreLabel.fontName = "Helvetica-Bold"
        highScoreLabel.fontSize = 16
        highScoreLabel.horizontalAlignmentMode = .left
        highScoreLabel.fontColor = .yellow
        highScoreLabel.position = CGPoint(x: 25, y: self.size.height-95) // Beispielposition
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

    func updateLevelLabel() {
        levelLabel.text = "Level: \(level)"
    }
    
    func updateHighScoreLabel() {
        highScoreLabel.text = "Highscore: \(hiScore)"
    }

    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }
    
    func updateLivesLabel() {
        livesLabel.text = "Leben: \(lives)"
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
            
            obstacle.removeFromParent()
            
            lives -= 1
            
            updateLivesLabel()
            
            if lives <= 0 {
                        gameOver()
            }

        }

    func gameOver() {
            print("Spiel beendet!")
                                
            // Zeige eine Nachricht an oder starte die Szene neu
            let gameOverLabel = SKLabelNode(text: "Game Over")
            gameOverLabel.fontName = "Helvetica-Bold"
            gameOverLabel.fontSize = 48
            gameOverLabel.fontColor = .red
            gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
            addChild(gameOverLabel)
            
            // Stoppe alle Aktionen in der Szene
            self.isPaused = true
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
        
        boost.position.x = player.position.x
        
    }

    func checkForLevelUp() {
        if score % 500 == 0 { // Überprüft, ob der Punktestand ein Vielfaches von 1000 ist
            levelUp()
        }
    }
   
    func spawnObstacle() {
        
        score += 10
        updateHighScore(currentScore: score)
        updateScoreLabel()
        checkForLevelUp()
        
        let obstacle = SKSpriteNode(imageNamed: "asteroid8")
        obstacle.position = CGPoint(x: CGFloat.random(in: frame.minX+75...frame.maxX-75), y: frame.maxY+80)
        
        // Physik-Körper hinzufügen, falls benötigt
        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        obstacle.physicsBody?.isDynamic = false // true?
        obstacle.physicsBody?.categoryBitMask = 2
        obstacle.physicsBody?.contactTestBitMask = 1
        obstacle.physicsBody?.collisionBitMask = 0
        
        addChild(obstacle) // Hindernis zur Szene hinzufügen
        obstacles.append(obstacle) // Hindernis zum Array hinzufügen
        
        // Bewegung nach unten und Entfernen des Hindernisses
        // let randomDuration = TimeInterval(CGFloat.random(in: 3.0...5.0))
        let randomDuration = TimeInterval(CGFloat.random(in: obstacleSpeed...obstacleSpeed*2))
        
        let moveAction = SKAction.moveTo(y: frame.minY - 50, duration: randomDuration)
        let removeAction = SKAction.run {
            self.obstacles.removeAll { $0 == obstacle } // Entfernt das Hindernis aus dem Array
            obstacle.removeFromParent() // Entfernt das Hindernis aus der Szene
            print("Hindernis entfernt. Aktive Hindernisse: \(self.obstacles.count)")
        }
        obstacle.run(SKAction.sequence([moveAction, removeAction]))
        
        print("Hindernis erzeugt. Aktive Hindernisse: \(obstacles.count)")
    }
}




