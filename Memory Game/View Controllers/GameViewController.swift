//
//  GameViewController.swift
//  Memory Game
//
//  Created by Paz Lavi  on 28/04/2021.
//

import UIKit



class GameViewController: UIViewController{
    
    
    @IBOutlet weak var movesCounterLBL: UILabel!
    @IBOutlet weak var timerLBL: UILabel!
    @IBOutlet weak var gameBoardView: UICollectionView!
    var gameLevel = GameLevel.mid // default value
    var movesCounter = 0
    var counter = 0
    var time :Timer? = nil
    var numOfPairs = 10
    var div = 5
    fileprivate let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    
    let game = MemoryGame()
    var cards = [Card]()
    
    
    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil);
        
    }
    
    override func viewDidLoad() {
        print(gameLevel)
        super.viewDidLoad()
        
        switch gameLevel {
        case GameLevel.easy:
            numOfPairs = 8
            div = 4
            break
        case GameLevel.mid:
            numOfPairs = 10
            div = 5
            break
        case GameLevel.hard:
            div = 6
            numOfPairs = 12
            break
    

        }
        
        
        game.delegate = self
        gameBoardView.dataSource = self
        gameBoardView.delegate = self
        gameBoardView.isScrollEnabled = false
        gameBoardView.isHidden = true
        gameBoardView.allowsSelection = true
        gameBoardView.backgroundColor = UIColor.clear
        
        let latlng = LocationManager.shared.requestForLocation()
        print(latlng?.toString ?? "nil")
        
        CardsManager.shared.getCardImages(numOfPairs:numOfPairs) { (cardsArray, error) in
            if let _ = error {
                // show alert
            }
            
            self.cards = cardsArray!
            self.setupNewGame()
            self.onStartGame()
        }
        
    }
    
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }
    
    override func viewDidDisappear(_ animated: Bool){
        super.viewDidDisappear(animated)
        
        if game.isPlaying {
            resetGame()
        }
    }
    
    func stopTimer(){
        self.time?.invalidate()
        self.time = nil
    }
    func startTimer(){
        timerLBL.text = "00:00"
        time = Timer()
        time?.invalidate()
        time = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerAction),
            userInfo: nil,
            repeats: true
        )
    }
    func setupNewGame() {
        cards = game.newGame(cardsArray: self.cards)
        gameBoardView.reloadData()
        
    }
    
    func resetGame() {
        game.restartGame()
        
    }
    
    func startNewGame(){
        setupNewGame()
        onStartGame()
    }
    func onStartGame() {
        gameBoardView.isHidden = false
        
        
        movesCounter = 0
        movesCounterLBL.text = "\(movesCounter)"
        counter = 0
        startTimer()
    }
    
    @objc func timerAction() {
        counter += 1
        
        timerLBL.text = TimeConvertor.prettyPrintSecToHHss(counter)
    }
    
    func gameOverDialog(){
        let alertController = UIAlertController(
            title: defaultAlertTitle,
            message: defaultAlertMessage,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: "NOPE", style: .cancel) {
            [weak self] (action) in
            self?.gameBoardView.isHidden = true
        }
        let playAgainAction = UIAlertAction(
            title: "YUP!", style: .default) {
            [weak self] (action) in
            self?.gameBoardView.isHidden = true
            self?.resetGame()
            self?.startNewGame()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(playAgainAction)
        
        self.present(alertController, animated: true) { }
    }
    func highScoreDialog() {
        let alert = UIAlertController(title: "Congratulations!", message: "New High Score!", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { (textField) in textField.placeholder = "Please Enter Your Name"}
        let name = alert.textFields![0]
        let saveNewHighScore = UIAlertAction(title: "Save High Score", style: .default, handler: {(alert: UIAlertAction!) in
          
             self.addNewHighScore(name.text!)
            self.gameOverDialog()
            
        })
        alert.addAction(saveNewHighScore)
        self.present(alert, animated: true) {
            

        }

    }
    func addNewHighScore(_ name:String)  {
        let record = Record(gameDuration: counter, playerName: name, playerLocation: LocationManager.shared.lastKnownLocation)
        ScoresManager.shared.addNewHighScore(record: record)

    }
}

// MARK: CollectionView settings
extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CardCell
        cell.showCard(false, animted: false)
        
        guard let card = game.cardAtIndex(indexPath.item) else { return cell }
        cell.card = card
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        if cell.shown { return }
        game.didSelectCard(cell.card)
        
        collectionView.deselectItem(at: indexPath, animated:true)
    }
    
}

// MARK: game protocol implementetion
extension GameViewController: MemoryGameProtocol {
    func memoryGameDidStart(_ game: MemoryGame) {
        gameBoardView.reloadData()
    }
    
    func memoryGame(_ game: MemoryGame, showCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card)
            else { continue
            }
            
            let cell = gameBoardView.cellForItem(
                at: IndexPath(item: index, section:0)
            ) as! CardCell
            cell.showCard(true, animted: true)
        }
    }
    func memoryGame(_ game: MemoryGame, hideCards cards: [Card]) {
        for card in cards {
            guard let index = game.indexForCard(card)
            else { continue
            }
            
            let cell = gameBoardView.cellForItem(
                at: IndexPath(item: index, section:0)
            ) as! CardCell
            
            cell.showCard(false, animted: true)
        }
    }
    func memoryGameDidEnd(_ game: MemoryGame) {
        stopTimer()
        if(ScoresManager.shared.isNewHighScore(gameDuration: counter)){
            highScoreDialog()
        }else{
            gameOverDialog()

        }
        
        resetGame()
    }
    func memoryGamePairSelected(){
        movesCounter = movesCounter + 1
        self.movesCounterLBL.text = "\(movesCounter)"
    }
}


// MARK: cell size
extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    // Collection view flow layout setup
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = Int(sectionInsets.left) * div
        let availableWidth = Int(view.frame.width) - paddingSpace
        let widthPerItem = availableWidth / div

        var res = CGSize(width: widthPerItem, height: widthPerItem)
        res.height = (collectionViewLayout.collectionView!.visibleSize.height / 4  - CGFloat(15))
        return res
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


