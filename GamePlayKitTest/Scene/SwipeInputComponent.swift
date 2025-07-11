//
//  SwipeInputComponent.swift
//  GamePlayKitTest
//
//  Created by Jesse Robinson Junior Simanjuntak on 09/07/25.
//


//
//  SwipeInputComponent.swift
//  GamePlayKitTest
//
//  Created by Jesse Robinson Junior Simanjuntak on 09/07/25.
//

import GameplayKit

class SwipeInputComponent: GKComponent {
    
    weak var movementComponent: MovementComponent?
    
    private var minimumSwipeDistance: CGFloat = 50
    private var maximumSwipeTime: TimeInterval = 0.5
    
    override func didAddToEntity() {
        super.didAddToEntity()
        
        // Get reference to movement component
        movementComponent = entity?.component(ofType: MovementComponent.self)
    }
    
    func handleSwipe(direction: SwipeDirection) {
        guard let movement = movementComponent else { return }
        
        switch direction {
        case .up:
            movement.jump()
        case .down:
            movement.duck()
        case .left:
            // Optional: you could add special left swipe behavior
            break
        case .right:
            // Optional: you could add special right swipe behavior
            break
        }
    }
}

enum SwipeDirection {
    case up
    case down
    case left
    case right
}