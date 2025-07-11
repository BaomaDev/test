// ObstacleType.swift

import SpriteKit

enum ObstacleType {
    case solid      // Cannot be touched at all
    case platform   // Can be stepped on from the top
    case low        // Must duck under

    var size: CGSize {
        switch self {
        case .solid: return CGSize(width: 40, height: 60)
        case .platform: return CGSize(width: 100, height: 20)
        case .low: return CGSize(width: 80, height: 30)
        }
    }

    var color: SKColor {
        switch self {
        case .solid: return .red
        case .platform: return .blue
        case .low: return .green
        }
    }

    var isStepable: Bool {
        return self == .platform
    }

    var positionYOffset: CGFloat {
        switch self {
        case .solid: return 0
        case .platform: return 60
        case .low: return 10
        }
    }

    var categoryBitMask: UInt32 {
        return PhysicsCategory.obstacle
    }

    var contactTestBitMask: UInt32 {
        return PhysicsCategory.player
    }

    var collisionBitMask: UInt32 {
        switch self {
        case .solid: return PhysicsCategory.player
        case .platform: return PhysicsCategory.player
        case .low: return PhysicsCategory.player
        }
    }

    func createNode(at position: CGPoint) -> SKSpriteNode {
        let node = SKSpriteNode(color: self.color, size: self.size)
        node.position = CGPoint(x: position.x, y: position.y + positionYOffset)
        node.name = "scrollable"

        let physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody.isDynamic = false
        physicsBody.categoryBitMask = self.categoryBitMask
        physicsBody.contactTestBitMask = self.contactTestBitMask
        physicsBody.collisionBitMask = self.collisionBitMask

        // For stepable platform, allow one-way contact
        if self == .platform {
            physicsBody.usesPreciseCollisionDetection = true
        }

        node.physicsBody = physicsBody
        return node
    }
}
