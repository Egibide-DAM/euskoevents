//
//  ItemViewController.swift
//  EuskoEvents
//
//  Created by Asier on 17/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemViewController: UIViewController {
    var json: JSON?
    var elemento = [JSON.Element]()
    var url: URL?

    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var territorio: UILabel!
    @IBOutlet weak var botonWeb: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        nombre.text = elemento.first?.1["documentName"].string
        fecha.text = elemento.first?.1["eventStartDate"].string
        if (elemento.first?.1["eventEndDate"].string != elemento.first?.1["eventStartDate"].string) {
            fecha.text = (fecha.text)! + " - " + (elemento.first?.1["eventEndDate"].string)!
        }
        territorio.text = elemento.first?.1["TerritoriohistoricoNombre"].string
        if (elemento.first?.1["friendlyUrl"] != nil) {
            url = (elemento.first?.1["friendlyUrl"].url!)!
            botonWeb.isEnabled = true

        } else {
            print("Disable botonWeb")
            botonWeb.isEnabled = false
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func irWeb(_ sender: Any) {
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
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
