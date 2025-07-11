// RenderComponent.swift

import SpriteKit
import GameplayKit

class RenderComponent: GKComponent {
    let node: SKSpriteNode
    
    init(node: SKSpriteNode) {
        self.node = node
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
