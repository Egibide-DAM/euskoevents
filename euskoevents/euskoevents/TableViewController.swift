//
//  TableViewController.swift
//  euskoevents
//
//  Created by Asier on 10/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {

    var tipoTabla: String!
    var odernado = [JSON.Element]()
    var odernadoPorFecha = [JSON.Element]()

    // Objeto de SwiftyJSON
    var json: JSON?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
                    
                    // Que día es hoy?
                    let formatter : DateFormatter = DateFormatter();
                    formatter.dateFormat = "yyyyMdd";
                    let hoy : String = formatter.string(from: NSDate.init(timeIntervalSinceNow: 0) as Date);
                    
                    // Filtrar dependiendo de lo solicitado
                    self.odernadoPorFecha = (self.json?.sorted(by: {$0.1["Fechainicioeventosinformato"] < $1.1["Fechainicioeventosinformato"]}))!
                    for a in self.odernadoPorFecha{
                        if self.tipoTabla == "Todos" {
                            self.odernado.append(a)
                        }
                        if self.tipoTabla == "Proximos" {
                            var fEvento = Int(a.1["Fechainicioeventosinformato"].string!)
                             if fEvento! > Int(hoy)! {
                                self.odernado.append(a)
                            }
                            
                        }
                        if self.tipoTabla == "Araba" {
                            var fEvento = Int(a.1["Fechainicioeventosinformato"].string!)
                            if fEvento! > Int(hoy)! {
                                if a.1["TerritoriohistoricoNombre"].string?.range(of:"ALAVA") != nil{
                                    self.odernado.append(a)
                                }
                            }
                            
                        }
                        if self.tipoTabla == "Bizkaia" {
                            var fEvento = Int(a.1["Fechainicioeventosinformato"].string!)
                            if fEvento! > Int(hoy)! {
                                if a.1["TerritoriohistoricoNombre"].string?.range(of:"BIZKAIA") != nil{
                                    self.odernado.append(a)
                                }
                            }
                            
                        }
                        if self.tipoTabla == "Gipuzkoa" {
                            var fEvento = Int(a.1["Fechainicioeventosinformato"].string!)
                            if fEvento! > Int(hoy)! {
                                if a.1["TerritoriohistoricoNombre"].string?.range(of:"GIPUZKOA") != nil{
                                    self.odernado.append(a)
                                }
                            }
                            
                        }
//Araba
//Bizkaia
//Gipuzkoa
                        
                    }
                    
                    
                    //self.odernado = (self.json?.sorted(by: {$0.1["TerritoriohistoricoNombre"] < $1.1["TerritoriohistoricoNombre"]}))!

                    
                    // Pedir la recarga de la tabla
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Si no hay datos, no hay filas
        return odernado.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let formatter : DateFormatter = DateFormatter();
        formatter.dateFormat = "yyyyMdd";
        let hoy : String = formatter.string(from: NSDate.init(timeIntervalSinceNow: 0) as Date);
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
        //cell.textLabel?.text = json?[indexPath.row]["documentName"].string
        /*
        if tipoTabla == "Todos" {
            cell.textLabel?.text = odernado[indexPath.row].1["TerritoriohistoricoNombre"].string!
            cell.textLabel?.text = (cell.textLabel?.text)! + " - " + odernado[indexPath.row].1["documentName"].string!
            cell.textLabel?.text = (cell.textLabel?.text)! + " - " + odernado[indexPath.row].1["Fechainicioeventosinformato"].string!
            return cell
        } else if tipoTabla == "Proximos" {
            var fEvento = Int(odernado[indexPath.row].1["Fechainicioeventosinformato"].string!)
            
            if fEvento! > Int(hoy)! {
                cell.textLabel?.text = odernado[indexPath.row].1["TerritoriohistoricoNombre"].string!
                cell.textLabel?.text = (cell.textLabel?.text)! + " - " + odernado[indexPath.row].1["documentName"].string!
                cell.textLabel?.text = (cell.textLabel?.text)! + " - " + odernado[indexPath.row].1["Fechainicioeventosinformato"].string!
                return cell
            }
 
        }
        */
    
        cell.textLabel?.text = odernado[indexPath.row].1["TerritoriohistoricoNombre"].string!
        cell.textLabel?.text = (cell.textLabel?.text)! + " - " + odernado[indexPath.row].1["documentName"].string!
        cell.textLabel?.text = (cell.textLabel?.text)! + " - " + odernado[indexPath.row].1["Fechainicioeventosinformato"].string!
        return cell
    }
    
}

