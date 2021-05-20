//
//  ViewController.swift
//  Memory Game
//
//  Created by Paz Lavi  on 28/04/2021.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var highBTN: UIButton!
    @IBOutlet weak var midBTN: UIButton!
    @IBOutlet weak var easyBTN: UIButton!
    @IBOutlet weak var topTenBTN: UIButton!
    @IBOutlet weak var playBTN: UIButton!
    var level : GameLevel = GameLevel.easy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectdButton(easyBTN)
        
        
    }
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction  func playClicked(_ sender: Any) {
        
    }
    
    @IBAction func topTenClicked(_ sender: Any) {
    }
    
    
    @IBAction func easySelected(_ sender: Any) {
        selectdButton(easyBTN)
        level = GameLevel.easy
        
    }
    
    
    @IBAction func midSelected(_ sender: Any) {
        selectdButton(midBTN)
        level = GameLevel.mid
        
    }
    
    
    @IBAction func highSelected(_ sender: Any) {
        selectdButton(highBTN)
        level = GameLevel.hard
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let vc = segue.destination as? GameViewController {
            vc.gameLevel = level
        }
    }
    
    func selectdButton(_ btn :UIButton )  {
        highBTN.backgroundColor = UIColor.blue
        midBTN.backgroundColor = UIColor.blue
        easyBTN.backgroundColor = UIColor.blue
        btn.backgroundColor = UIColor.black
    }
}

