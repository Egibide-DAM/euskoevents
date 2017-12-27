//
//  TableViewController.swift
//  EuskoEvents
//
//  Created by Asier on 10/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import UIKit

import SwiftyJSON

class TableViewController: UITableViewController {

    var tipoTabla: String!
    var lista = [Evento]()

    var odernadoPorFecha = [JSON.Element]()

    override func viewDidLoad() {

        super.viewDidLoad()

        // Ponemos el título de lo que estamos mostrando
        self.navigationItem.title = self.tipoTabla!

        // Que día es hoy?
        let hoy = Date()

        // Filtrar dependiendo de lo solicitado (ya están ordenados por fecha)
        var todos = [Evento]()
        if(soloProximosEventos) {
            for e in eventos {
                if(e.fechaInicio > hoy) {
                    todos.append(e)
                }
            }
        } else {
            todos = eventos
        }

        switch self.tipoTabla {
        case "Todos":
            lista = todos
        case "Araba":
            for e in todos {
                if(e.provincias.contains("ALAVA")) {
                    lista.append(e)
                }
            }
        case "Bizkaia":
            for e in todos {
                if(e.provincias.contains("BIZKAIA")) {
                    lista.append(e)
                }
            }
        case "Gipuzkoa":
            for e in todos {
                if(e.provincias.contains("GIPUZKOA")) {
                    lista.append(e)
                }
            }
        default:
            lista = todos
        }

        // Pedir la recarga de la tabla
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Si no hay datos, no hay filas
        return lista.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CeldaTableViewCell

        let evento = lista[indexPath.row]

        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "dd/MM/yyyy"

        celda.fecha.text = dateFmt.string(from: evento.fechaInicio)
        celda.titulo.text = evento.titulo
        celda.provincias.text = evento.provincias

        return celda
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "verItem") {
            let destino = segue.destination as! ItemViewController
            destino.evento = lista[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }

}

