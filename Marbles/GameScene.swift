//
//  GameScene.swift
//  Marbles
//
//  Created by Jeffery Mason on 4/10/21.
//

import SpriteKit

class Marble: SKSpriteNode { }

class GameScene: SKScene {
    var marbles = ["marbleBlue", "marbleGreen", "marblePurple", "marbleRed", "marbleYellow"]
    
    let scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Thin")
    var matchedMarbles = Set<Marble>()
    
    var score = 0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formattedScore = formatter.string(from: score as NSNumber) ?? "0"
            scoreLabel.text = "SCORE: \(formattedScore)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        let marble = SKSpriteNode(imageNamed: "marbleBlue")
        let marbleRadius = marble.frame.width / 2.0
        
        scoreLabel.fontSize = 72
        scoreLabel.position = CGPoint(x: 20, y: 20)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.zPosition = 100
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        for i in stride(from: marbleRadius, to: view.bounds.width - marbleRadius, by: marble.frame.width) {
            for j in stride(from: 100, to: view.bounds.height - marbleRadius, by: marble.frame.height) {
                let marbleType = marbles.randomElement()!
                let marble = Marble(imageNamed: marbleType)
                marble.position = CGPoint(x: i, y: j)
                marble.name = marbleType
                
                marble.physicsBody = SKPhysicsBody(circleOfRadius: marbleRadius)
                marble.physicsBody?.allowsRotation = false
                marble.physicsBody?.friction = 0
                marble.physicsBody?.restitution = 0
                
                addChild(marble)
            }
        }
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame.inset(by: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
//    func getMatches(from node: Marble) {
//        for body in node.physicsBody!.allContactedBodies() {
//            guard let marble = body.node as? Marble else { continue }
//            guard marble.name == node.name else { continue }
//
//            if !matchedMarbles.contains(marble) {
//                matchedMarbles.insert(marble)
//                getMatches(from: marble)
//            }
//        }
//    }
    
    func getMatches(from startMarble: Marble) {
        let matchWidth = startMarble.frame.width * startMarble.frame.width
        
        for node in children {
            guard let marble = node as? Marble else { continue }
            guard marble.name == startMarble.name else { continue }
            
            let dist = distance(from: startMarble, to: marble)
            
            guard dist < matchWidth else { continue }
            
            if !matchedMarbles.contains(marble) {
                matchedMarbles.insert(marble)
                getMatches(from: marble)
            }
        }
    }
    
    func distance(from: Marble, to: Marble) -> CGFloat {
        return (from.position.x - to.position.x) * (from.position.x - to.position.x) + (from.position.y - to.position.y) * (from.position.y - to.position.y)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let position = touches.first?.location(in: self) else { return }
        guard let tappedMarble = nodes(at: position).first(where: { $0 is Marble}) as? Marble else { return }
        
        matchedMarbles.removeAll(keepingCapacity: true)
        
        getMatches(from: tappedMarble)
        
        if matchedMarbles.count >= 3 {
            score += Int(pow(2, Double(min(matchedMarbles.count, 8))))
            
            for marble in matchedMarbles {
                if let particles = SKEmitterNode(fileNamed: "Blast") {
                    particles.position = marble.position
                    addChild(particles)
                    
                    let removeAfterMatched = SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.removeFromParent()])
                    particles.run(removeAfterMatched)
                }
                
                marble.removeFromParent()
            }
        }
    }
    
}

