//
//  MapViewController.swift
//  EuskoEvents
//
//  Created by Asier on 10/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import UIKit

import MapKit
import SafariServices

class Anotacion: NSObject, MKAnnotation {

    let title: String? // MKAnnotation
    let coordinate: CLLocationCoordinate2D // MKAnnotation
    let fecha: String
    let url: URL?

    init(evento e: Evento) {

        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "dd/MM/yyyy"

        self.title = e.titulo
        self.coordinate = CLLocationCoordinate2D(latitude: e.latitud!, longitude: e.longitud!)
        self.fecha = dateFmt.string(from: e.fechaInicio)
        self.url = e.url

        super.init()
    }

    var subtitle: String? {
        return fecha
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

        for e in eventos {

            if e.latitud != nil && e.longitud != nil {
                let anotacion = Anotacion(evento: e)
                if(soloProximosEventos) {
                    if(e.fechaInicio > hoy) {
                        self.mapView.addAnnotation(anotacion)
                    }
                } else {
                    self.mapView.addAnnotation(anotacion)
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

        guard let annotation = annotation as? Anotacion else { return nil }

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
            if annotation.url != nil {
                view.rightCalloutAccessoryView = button
            }
        }

        return view
    }

    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {

            let anotacion = view.annotation as! Anotacion

            if let url = anotacion.url {
                let vc = SFSafariViewController(url: url)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
