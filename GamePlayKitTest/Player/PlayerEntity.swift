//
//  PlayerEntity.swift
//  GamePlayKitTest
//
//  Created by Jesse Robinson Junior Simanjuntak on 09/07/25.
//

import GameplayKit

class PlayerEntity: GKEntity {
    init(name: String = "Nephyr", texture: SKTexture, size: CGSize){
        super.init()
        addComponent(PlayerInfoComponent(name: name))
        addComponent(MovementComponent())
        addComponent(RenderComponent(texture: texture, size: size))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
