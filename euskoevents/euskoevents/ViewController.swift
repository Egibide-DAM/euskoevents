//
//  ViewController.swift
//  EuskoEvents
//
//  Created by Asier on 10/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// Objeto de SwiftyJSON
var eventos = [Evento]()

// Selección global
var soloProximosEventos = false

class ViewController: UIViewController {

    @IBOutlet weak var selectorProximos: UISegmentedControl!

    @IBAction func selector(_ sender: UISegmentedControl) {
        soloProximosEventos = sender.selectedSegmentIndex == 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Todos | Próximos
        soloProximosEventos = selectorProximos.selectedSegmentIndex == 0

        // REF: Tamaño de la barra de navegación de iOS 11: https://chariotsolutions.com/blog/post/large-titles-ios-11/
        navigationController?.navigationBar.prefersLargeTitles = true

        // REF: Desactivar verificación de HTTPS: https://stackoverflow.com/a/30732693/5136913
        let url = "http://opendata.euskadi.eus/contenidos/ds_eventos/eventos_turisticos/opendata/agenda.json"

        // No podemos usar .responseJSON(), porque no es un JSON válido
        Alamofire.request(url, method: .get).validate().responseString { response in
            switch response.result {
            case .success(let value):

                // Arreglamos los desperfectos
                var temp = value.dropFirst(13) // jsonCallback(
                temp = temp.dropLast(2) // );

                // La codificación de caractéres tampoco es válida, debería ser .utf8
                if let dataFromString = temp.data(using: .isoLatin1, allowLossyConversion: false) {

                    // Convertir el String en JSON con SwiftyJSON
                    let json = try! JSON(data: dataFromString)

                    var eventosJSON = [Evento]()

                    for (_, datos) in json { // El primer campo de la tupla es un id numérico

                        let titulo = datos["documentName"].stringValue

                        // REF: Convertir un String a Date: https://iswift.org/cookbook/get-nsdate-from-string-using-format
                        let dateFmt = DateFormatter()
                        dateFmt.timeZone = TimeZone.current
                        dateFmt.dateFormat = "dd/MM/yyyy"

                        let fechaInicio = dateFmt.date(from: datos["eventStartDate"].stringValue)
                        let fechaFin = dateFmt.date(from: datos["eventEndDate"].stringValue)

                        let provincias = datos["TerritoriohistoricoNombre"].stringValue

                        let url = URL(string: datos["friendlyUrl"].stringValue)

                        let latitud = Double(datos["latwgs84"].stringValue)
                        let longitud = Double(datos["lonwgs84"].stringValue)

                        let nuevoEvento = Evento(
                            titulo: titulo,
                            fechaInicio: fechaInicio!,
                            fechaFin: fechaFin!,
                            provincias: provincias,
                            url: url,
                            latitud: latitud,
                            longitud: longitud
                        )

                        eventosJSON.append(nuevoEvento)
                    }

                    eventos = eventosJSON.sorted()

                }
            case .failure(let error):
                print(error)

            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {

        if segue.destination is TableViewController {

            let destino = segue.destination as! TableViewController

            switch segue.identifier! {
            case "verTablaTodos":
                destino.tipoTabla = "Todos"
            case "verTablaProximos":
                destino.tipoTabla = "Proximos"
            case "verTablaAraba":
                destino.tipoTabla = "Araba"
            case "verTablaBizkaia":
                destino.tipoTabla = "Bizkaia"
            case "verTablaGipuzkoa":
                destino.tipoTabla = "Gipuzkoa"
            default:
                print("Segue desconocida...")
            }

        }

    }

}

