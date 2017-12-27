//
//  ItemViewController.swift
//  EuskoEvents
//
//  Created by Asier on 17/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import UIKit
import SwiftyJSON
import Eureka
import SafariServices

class ItemViewController: FormViewController {

    var json: JSON?
    var elemento = [JSON.Element]()
    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section("Detalles")
        <<< LabelRow() {
            $0.title = "Fecha"
            $0.value = elemento.first?.1["eventStartDate"].string
            if (elemento.first?.1["eventEndDate"].string != elemento.first?.1["eventStartDate"].string) {
                $0.value = $0.value! + " - " + (elemento.first?.1["eventEndDate"].string)!
            }
        }
        <<< LabelRow() { row in
            row.title = "Título"
            row.value = elemento.first?.1["documentName"].string

            // REF: Etiquetas multilínea: https://stackoverflow.com/a/38095587/5136913
            row.cell.detailTextLabel?.numberOfLines = 0
        }
        <<< LabelRow() { row in
            row.title = "Provincias"
            row.value = elemento.first?.1["TerritoriohistoricoNombre"].string
        }
        if (elemento.first?.1["friendlyUrl"] != nil) {
            url = (elemento.first?.1["friendlyUrl"].url!)!
            form
                +++ Section("Información adicional")
            <<< ButtonRow { row in
                row.title = "Ver en la web"
            }.onCellSelection { cell, row in
                // REF: Mostrar la URL en un navegador integrado: https://stackoverflow.com/a/46729252/5136913
                let vc = SFSafariViewController(url: self.url!)
                self.present(vc, animated: true, completion: nil)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
