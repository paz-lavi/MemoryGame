//
//  TopTenViewController.swift
//  Memory Game
//
//  Created by Paz Lavi  on 13/05/2021.
//

import UIKit
import MapKit

class TopTenViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var recordList: UITableView!
    var records : [Record]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        records = ScoresManager.shared.highScores!
        records?.reverse()
        map.delegate = self
        if((records?.count ?? -1 ) > 0){
            let initialLocation = CLLocation(latitude: records![0].playerLocation!.lat, longitude: records![0].playerLocation!.lng)
            map.centerToLocation(initialLocation)
            
        }
        
        recordList.dataSource = self
        recordList.delegate = self
        
    }
    
    @IBAction func backClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil);
        
    }
    
}


// MARK: Table View (records)
extension TopTenViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var c = 0
        if(records != nil){
            c = records!.count < 10 ? records!.count : 10
        }
        
        return c
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! RecordCell
        cell.playerLBL.text = "Player Name: \(records?[indexPath.item].playerName ?? "empty")"
        let t = TimeConvertor.prettyPrintSecToHHss(records?[indexPath.item].gameDuration ?? -1)
        cell.scoreLBL.text = "Game Duration: \(t)"
        cell.locationLBL.text = "Game Location: \(records?[indexPath.item].playerLocation?.toString ?? "empty")"
        cell.placeLBL.text = "Place: #\(indexPath.item + 1)"
        if(records?[indexPath.item].playerLocation != nil){
            cell.loc = CLLocation(latitude: records![indexPath.item].playerLocation!.lat, longitude: records![indexPath.item].playerLocation!.lng)
        }
        //add to map
        let artwork = Artwork(
            record: records![indexPath.item], place: (indexPath.item + 1))
        map.addAnnotation(artwork)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell =  tableView.cellForRow(at: indexPath) as! RecordCell
        if (cell.loc != nil){
            self.map.centerToLocation(cell.loc!)
        }
        
    }
    
}

// MARK: MAP
private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
}


// MARK: artwork
extension TopTenViewController: MKMapViewDelegate {
    // 1
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Artwork else {
            return nil
        }
        // 3
        let identifier = "artwork"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
        }
        return view
    }
}

