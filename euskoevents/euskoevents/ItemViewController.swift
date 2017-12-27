//
//  ItemViewController.swift
//  EuskoEvents
//
//  Created by Asier on 17/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import UIKit

import Eureka
import SafariServices

class ItemViewController: FormViewController {

    var evento: Evento?

    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "dd/MM/yyyy"

        form +++ Section("Detalles")
        <<< LabelRow() {
            $0.title = "Fecha"
            if let fechaInicio = evento?.fechaInicio {
                $0.value = dateFmt.string(from: fechaInicio)

                if let fechaFin = evento?.fechaFin, fechaInicio != fechaFin {
                    $0.value = $0.value! + " - \(dateFmt.string(from: fechaFin))"
                }
            }
        }
        <<< LabelRow() { row in
            row.title = "Título"
            row.value = evento?.titulo

            // REF: Etiquetas multilínea: https://stackoverflow.com/a/38095587/5136913
            row.cell.detailTextLabel?.numberOfLines = 0
        }
        <<< LabelRow() { row in
            row.title = "Provincias"
            row.value = evento?.provincias
        }

        if let url = evento?.url {
            form
                +++ Section("Información adicional")
            <<< ButtonRow { row in
                row.title = "Ver en la web"
            }.onCellSelection { cell, row in
                // REF: Mostrar la URL en un navegador integrado: https://stackoverflow.com/a/46729252/5136913
                let vc = SFSafariViewController(url: url)
                self.present(vc, animated: true, completion: nil)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
