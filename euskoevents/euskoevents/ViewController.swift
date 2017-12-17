//
//  ViewController.swift
//  euskoevents
//
//  Created by Asier on 10/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    // Objeto de SwiftyJSON
    var json: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
                    self.json = try! JSON(data: dataFromString)
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
        if (segue.identifier == "verTablaTodos"){
            let destino = segue.destination as! TableViewController;
            destino.json  = json
            destino.tipoTabla = "Todos"
        }
        if (segue.identifier == "verTablaProximos"){
            let destino = segue.destination as! TableViewController;
            destino.json  = json
            destino.tipoTabla = "Proximos"
        }
        if (segue.identifier == "verTablaAraba"){
            let destino = segue.destination as! TableViewController;
            destino.json  = json
            destino.tipoTabla = "Araba"
        }
        if (segue.identifier == "verTablaBizkaia"){
            let destino = segue.destination as! TableViewController;
            destino.json  = json
            destino.tipoTabla = "Bizkaia"
        }
        if (segue.identifier == "verTablaGipuzkoa"){
            let destino = segue.destination as! TableViewController;
            destino.json  = json
            destino.tipoTabla = "Gipuzkoa"
        }
        if (segue.identifier == "verMapa"){
            let destino = segue.destination as! MapViewController;
            destino.json  = json
        }
    }

}

