//
//  ObstacleType.swift
//  GamePlayKitTest
//
//  Created by Jesse Robinson Junior Simanjuntak on 11/07/25.
//


// ObstacleType.swift

import SpriteKit

enum ObstacleType {
    case noTouch      // Cannot be touched at all
    case stepable     // Can be stepped on from the top
    case duckable     // Must duck under
    
    var size: CGSize {
        switch self {
        case .noTouch: return CGSize(width: 40, height: 60)
        case .stepable: return CGSize(width: 100, height: 20)
        case .duckable: return CGSize(width: 80, height: 60)
        }
    }
    
    var color: SKColor {
        switch self {
        case .noTouch: return .red
        case .stepable: return .blue
        case .duckable: return .green
        }
    }
    
    var positionYOffset: CGFloat {
        return 0
    }
    
    func createNode(at position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(color: self.color, size: self.size)
        node.position = CGPoint(x: position.x, y: position.y + positionYOffset)
        node.name = "scrollable"
        
        switch self {
        case .noTouch:
            setupNoTouchPhysics(for: node)
        case .stepable:
            setupStepablePhysics(for: node)
        case .duckable:
            setupDuckablePhysics(for: node)
        }
        
        return node
    }
    
    private func setupNoTouchPhysics(for node: SKSpriteNode) {
        let physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = PhysicsCategory.obstacle
        physicsBody.contactTestBitMask = PhysicsCategory.player
        physicsBody.collisionBitMask = PhysicsCategory.player
        
        node.physicsBody = physicsBody
        node.userData = ["obstacleType": "noTouch"]
    }
    
    private func setupStepablePhysics(for node: SKSpriteNode) {
        node.physicsBody = nil // Remove default physics body
        node.userData = ["obstacleType": "stepable"]
        
        // Create safe zone on top (invisible)
        let safeZone = SKSpriteNode(color: .clear, size: CGSize(width: self.size.width, height: 15))
        safeZone.position = CGPoint(x: 0, y: self.size.height/2 - 7.5)
        safeZone.physicsBody = SKPhysicsBody(rectangleOf: safeZone.size)
        safeZone.physicsBody?.isDynamic = false
        safeZone.physicsBody?.categoryBitMask = PhysicsCategory.ground // Acts as ground
        safeZone.physicsBody?.contactTestBitMask = PhysicsCategory.player
        safeZone.physicsBody?.collisionBitMask = PhysicsCategory.player
        safeZone.name = "safeZone"
        node.addChild(safeZone)
        
        // Create damage zones on left and right sides
        let damageZoneWidth: CGFloat = 15
        let damageZoneHeight = self.size.height - 15 // Exclude top safe area
        
        // Left damage zone
        let leftDamageZone = SKSpriteNode(color: .clear, size: CGSize(width: damageZoneWidth, height: damageZoneHeight))
        leftDamageZone.position = CGPoint(x: -self.size.width/2 + damageZoneWidth/2, y: -7.5)
        leftDamageZone.physicsBody = SKPhysicsBody(rectangleOf: leftDamageZone.size)
        leftDamageZone.physicsBody?.isDynamic = false
        leftDamageZone.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        leftDamageZone.physicsBody?.contactTestBitMask = PhysicsCategory.player
        leftDamageZone.physicsBody?.collisionBitMask = PhysicsCategory.none
        leftDamageZone.name = "damageZone"
        node.addChild(leftDamageZone)
        
        // Right damage zone
        let rightDamageZone = SKSpriteNode(color: .clear, size: CGSize(width: damageZoneWidth, height: damageZoneHeight))
        rightDamageZone.position = CGPoint(x: self.size.width/2 - damageZoneWidth/2, y: -7.5)
        rightDamageZone.physicsBody = SKPhysicsBody(rectangleOf: rightDamageZone.size)
        rightDamageZone.physicsBody?.isDynamic = false
        rightDamageZone.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        rightDamageZone.physicsBody?.contactTestBitMask = PhysicsCategory.player
        rightDamageZone.physicsBody?.collisionBitMask = PhysicsCategory.none
        rightDamageZone.name = "damageZone"
        node.addChild(rightDamageZone)
        
        // Bottom collision zone (prevents player from going through bottom)
        let bottomZone = SKSpriteNode(color: .clear, size: CGSize(width: self.size.width - 30, height: 10))
        bottomZone.position = CGPoint(x: 0, y: -self.size.height/2 + 5)
        bottomZone.physicsBody = SKPhysicsBody(rectangleOf: bottomZone.size)
        bottomZone.physicsBody?.isDynamic = false
        bottomZone.physicsBody?.categoryBitMask = PhysicsCategory.ground
        bottomZone.physicsBody?.contactTestBitMask = PhysicsCategory.player
        bottomZone.physicsBody?.collisionBitMask = PhysicsCategory.player
        bottomZone.name = "bottomZone"
        node.addChild(bottomZone)
    }
    
    private func setupDuckablePhysics(for node: SKSpriteNode) {
        // Only the upper half has collision
        node.physicsBody = nil // Remove default physics body
        node.userData = ["obstacleType": "duckable"]
        
        // Create collision zone only on upper half
        let collisionHeight = self.size.height * 0.1 // Upper 60% of the obstacle
        let collisionZone = SKSpriteNode(color: .clear, size: CGSize(width: self.size.width, height: collisionHeight))
        collisionZone.position = CGPoint(x: 0, y: self.size.height/2 - collisionHeight/2)
        collisionZone.physicsBody = SKPhysicsBody(rectangleOf: collisionZone.size)
        collisionZone.physicsBody?.isDynamic = false
        collisionZone.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        collisionZone.physicsBody?.contactTestBitMask = PhysicsCategory.player
        collisionZone.physicsBody?.collisionBitMask = PhysicsCategory.player
        collisionZone.name = "collisionZone"
        node.addChild(collisionZone)
        
        // Optional: Add visual indicator for duck zone
        let duckZone = SKSpriteNode(color: .yellow, size: CGSize(width: self.size.width, height: self.size.height * 0.4))
        duckZone.position = CGPoint(x: 0, y: -self.size.height/2 + duckZone.size.height/2)
        duckZone.name = "duckZone"
        node.addChild(duckZone)
    }
}
