//
//  Artwork.swift
//  Memory Game
//
//  Created by Paz Lavi  on 13/05/2021.
//

import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let place : Int
    let record: Record
    let coordinate: CLLocationCoordinate2D
    
    init(
        record: Record,place :Int,
        coordinate: CLLocationCoordinate2D
    ) {
        self.record = record
        self.place = place
        self.coordinate = coordinate
        self.title = "#\(place)"
        
        super.init()
    }
    
    convenience init(
        record: Record, place :Int
    ) {
        self.init(record: record , place: place, coordinate: CLLocationCoordinate2D(latitude:  record.playerLocation!.lat , longitude:  record.playerLocation!.lng ))
        
    }
    
    var subtitle: String? {
        return "Player Name: \(record.playerName), Game Duration: \(record.gameDuration)"
    }
}
