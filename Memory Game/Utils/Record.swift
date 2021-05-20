//
//  Record.swift
//  Memory Game
//
//  Created by Paz Lavi  on 30/04/2021.
//

import Foundation

class Record: Codable, Comparable{
    
    
    var gameDuration: Int = 0
    var playerName:String = ""
    var playerLocation:LatLng?
    var gameDate:Date? = nil
    
    
    init() {
        
    }
    
    init (gameDuration:Int, playerName:String, playerLocation:LatLng?){
        self.gameDuration = gameDuration
        self.playerName = playerName
        self.playerLocation = playerLocation ?? nil
        self.gameDate = Date()
        
    }
    static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.gameDuration == rhs.gameDuration
    }
    
    static func < (lhs: Record, rhs: Record) -> Bool {
        return (lhs.gameDuration - rhs.gameDuration) > 0
        
    }
}


