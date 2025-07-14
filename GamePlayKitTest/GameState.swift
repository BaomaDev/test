//
//  GameState.swift
//  GamePlayKitTest
//
//  Created by Jesse Robinson Junior Simanjuntak on 14/07/25.
//


class GameState {
    static let shared = GameState()
    private init() {}
    
    var score: Int = 0
}
