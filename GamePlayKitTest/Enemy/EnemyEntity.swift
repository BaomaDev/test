//
//  EnemyEntity.swift
//  GamePlayKitTest
//
//  Created by Jesse Robinson Junior Simanjuntak on 14/07/25.
//

import SpriteKit
import GameplayKit

class EnemyEntity: GKEntity {
    
    private let moveSpeed: CGFloat = 110.0
    private var isDucking = false
    private var originalColor: SKColor = .purple
    private var isGrounded = false
    
    let sprite: SKSpriteNode
    weak var playerEntity: PlayerEntity?
    
    override init() {
        let size = CGSize(width: 64, height: 64)
        sprite = SKSpriteNode(color: originalColor, size: size)
        sprite.name = "Enemy"
        sprite.alpha = 0.8 // Make it slightly transparent to differentiate from player
        
        super.init()
        
        // Make enemy physics body similar to player but without collision
        let body = SKPhysicsBody(rectangleOf: size)
        body.isDynamic = true
        body.affectedByGravity = true
        body.allowsRotation = false
        body.restitution = 0
        body.friction = 1
        body.categoryBitMask = PhysicsCategory.none // No collision category
        body.contactTestBitMask = PhysicsCategory.ground // Only interact with ground
        body.collisionBitMask = PhysicsCategory.ground // Only collide with ground
        
        sprite.physicsBody = body
        
        let renderComponent = RenderComponent(node: sprite)
        addComponent(renderComponent)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let player = playerEntity else { return }
        
        let distance = player.distance
        
        switch distance {
        case 3:
            // Enemy is not visible (normal state)
            sprite.isHidden = true
            
        case 2:
            // Enemy appears outside screen (right side)
            sprite.isHidden = false
            sprite.position.x = 400 // Outside screen to the right
            sprite.physicsBody?.velocity.dx = 0 // Stop horizontal movement
            
        case 1:
            // Enemy chases player (moves from right to left gap of 50)
            sprite.isHidden = false
            let targetX = player.sprite.position.x + 50 // 50 gap behind player
            
            if sprite.position.x > targetX {
                sprite.physicsBody?.velocity.dx = -moveSpeed // Move left towards player
            } else {
                sprite.physicsBody?.velocity.dx = moveSpeed * 0.5 // Slow down when close
            }
            
            // Limit how far left the enemy can go
            if sprite.position.x < -250 {
                sprite.position.x = -250
                sprite.physicsBody?.velocity.dx = 0
            }
            
        case 0:
            // Enemy is above player
            sprite.isHidden = false
            sprite.position.x = player.sprite.position.x
            sprite.position.y = player.sprite.position.y + 100 // 100 units above player
            sprite.physicsBody?.velocity.dx = 0
            sprite.physicsBody?.velocity.dy = 0
            
        default:
            sprite.isHidden = true
        }
    }

    func jump() {
        guard isOnGround else { return }
        sprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
    }

    func duck() {
        guard !isDucking else { return }
        isDucking = true

        sprite.color = .magenta

        // Save original size
        let originalSize = CGSize(width: 64, height: 64)
        
        // Duck size: shorter height, wider width
        let duckSize = CGSize(
            width: originalSize.width + (originalSize.height / 2),
            height: originalSize.height / 2
        )

        // Move down to stay grounded
        sprite.position.y -= originalSize.height / 4
        sprite.size = duckSize

        // Apply new physics body (but keep it non-colliding)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: duckSize)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.affectedByGravity = true
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.restitution = 0
        sprite.physicsBody?.friction = 1
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.none
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.ground
        sprite.physicsBody?.collisionBitMask = PhysicsCategory.ground

        // Revert after 1 second
        let wait = SKAction.wait(forDuration: 1.0)
        let restore = SKAction.run { [weak self] in
            guard let self = self else { return }
            
            self.sprite.position.y += originalSize.height / 4
            self.sprite.size = originalSize
            self.sprite.physicsBody = SKPhysicsBody(rectangleOf: originalSize)
            self.sprite.physicsBody?.isDynamic = true
            self.sprite.physicsBody?.affectedByGravity = true
            self.sprite.physicsBody?.allowsRotation = false
            self.sprite.physicsBody?.restitution = 0
            self.sprite.physicsBody?.friction = 1
            self.sprite.physicsBody?.categoryBitMask = PhysicsCategory.none
            self.sprite.physicsBody?.contactTestBitMask = PhysicsCategory.ground
            self.sprite.physicsBody?.collisionBitMask = PhysicsCategory.ground
            
            self.sprite.color = self.originalColor
            self.isDucking = false
        }

        sprite.run(SKAction.sequence([wait, restore]))
    }

    var isOnGround: Bool {
        guard let velocity = sprite.physicsBody?.velocity else { return false }
        return abs(velocity.dy) < 1.0
    }
    
    // Mirror player actions for visual effect
    func mirrorPlayerAction(_ action: String) {
        switch action {
        case "jump":
            jump()
        case "duck":
            duck()
        default:
            break
        }
    }
}