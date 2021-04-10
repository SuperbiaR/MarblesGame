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
    
    override func didMove(to view: SKView) {
        
        let marble = SKSpriteNode(imageNamed: "marbleBlue")
        let marbleRadius = marble.frame.width / 2.0
        
        for i in stride(from: marbleRadius, to: view.bounds.width - marbleRadius, by: marble.frame.width) {
            for j in stride(from: 100, to: view.bounds.height - marbleRadius, by: marble.frame.height) {
                let marbleType = marbles.randomElement()!
                let marble = Marble(imageNamed: marbleType)
                marble.position = CGPoint(x: i, y: j)
                marble.name = marbleType
                addChild(marble)
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
