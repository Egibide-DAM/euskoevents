//
//  MapViewController.swift
//  EuskoEvents
//
//  Created by Asier on 10/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import UIKit

import MapKit

class Artwork: NSObject, MKAnnotation {

    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D

    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate

        super.init()
    }

    var subtitle: String? {
        return locationName
    }

}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    let regionRadius: CLLocationDistance = 100000

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self

        // Que día es hoy?
        let hoy = Date()

        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "dd/MM/yyyy"

        for e in eventos {

            if let latitud = e.latitud, let longitud = e.longitud {
                let artwork = Artwork(title: e.titulo,
                                      locationName: dateFmt.string(from: e.fechaInicio),
                                      coordinate: CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
                )
                if(soloProximosEventos) {
                    if(e.fechaInicio > hoy) {
                        self.mapView.addAnnotation(artwork)
                    }
                } else {
                    self.mapView.addAnnotation(artwork)
                }
            }

        }

        // Centrar el mapa
        let initialLocation = CLLocation(latitude: 43.1714635, longitude: -2.630595900000003)
        centerMapOnLocation(location: initialLocation)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension UIViewController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let annotation = annotation as? Artwork else { return nil }

        let identifier = "marker"
        var view: MKMarkerAnnotationView
        let button = UIButton(type: .detailDisclosure) as UIButton // button with info sign

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = button
        }

        return view
    }

    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            // TODO: Ir a evento
            //print(mapView.selectedAnnotations.first)
            print("PULSADO") // your annotation's title
            //Perform a segue here to navigate to another viewcontroller
        }
    }
}
