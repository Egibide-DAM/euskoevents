//
//  ViewController.swift
//  euskoevents
//
//  Created by Asier on 10/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "verTablaTodos"){
            let destino = segue.destination as! TableViewController;
            destino.tipoTabla = "Todos"
        }
        if (segue.identifier == "verTablaProximos"){
            let destino = segue.destination as! TableViewController;
            destino.tipoTabla = "Proximos"
        }
        if (segue.identifier == "verTablaAraba"){
            let destino = segue.destination as! TableViewController;
            destino.tipoTabla = "Araba"
        }
        if (segue.identifier == "verTablaBizkaia"){
            let destino = segue.destination as! TableViewController;
            destino.tipoTabla = "Bizkaia"
        }
        if (segue.identifier == "verTablaGipuzkoa"){
            let destino = segue.destination as! TableViewController;
            destino.tipoTabla = "Gipuzkoa"
        }
    }

}

