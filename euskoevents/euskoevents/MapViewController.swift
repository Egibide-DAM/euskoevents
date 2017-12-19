//
//  MapViewController.swift
//  euskoevents
//
//  Created by Asier on 10/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}

class MapViewController: UIViewController {
    // Objeto de SwiftyJSON
    var json: JSON?
    var odernadoPorFecha = [JSON.Element]()
    var mostrarMapa = [JSON.Element]()
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 100000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self


        // Que día es hoy?
        let formatter : DateFormatter = DateFormatter();
        formatter.dateFormat = "yyyyMdd";
        let hoy : String = formatter.string(from: NSDate.init(timeIntervalSinceNow: 0) as Date);
        
        
        // no es necesario ordenar
        self.odernadoPorFecha = (self.json?.sorted(by: {$0.1["Fechainicioeventosinformato"] < $1.1["Fechainicioeventosinformato"]}))!
        for a in self.odernadoPorFecha{
            let fEvento = Int(a.1["Fechainicioeventosinformato"].string!)
            if fEvento! > Int(hoy)! {
                
                if a.1["latwgs84"] != nil {
                    print (a.1["latwgs84"] )
                    let artwork = Artwork(title: a.1["documentName"].string!,
                                          locationName: a.1["eventStartDate"].string!,
                                          discipline: "Sculpture",
                                          coordinate: CLLocationCoordinate2D(latitude: Double(a.1["latwgs84"].string!)!, longitude: Double(a.1["lonwgs84"].string!)!))
                    self.mapView.addAnnotation(artwork)
                }
            }
        }
        
        //end: descargar datos
        

        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 43.1714635, longitude: -2.630595900000003)
        centerMapOnLocation(location: initialLocation)

        
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController: MKMapViewDelegate {
    // 1
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Artwork else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}

