//
//  RecordCell.swift
//  Memory Game
//
//  Created by Paz Lavi  on 13/05/2021.
//

import Foundation
import UIKit
import MapKit

class RecordCell: UITableViewCell{
    
    
    @IBOutlet weak var placeLBL: UILabel!
    @IBOutlet weak var locationLBL: UILabel!
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var playerLBL: UILabel!
    var loc :CLLocation?
    
}
