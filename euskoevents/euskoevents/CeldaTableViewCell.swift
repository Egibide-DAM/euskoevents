//
//  CeldaTableViewCell.swift
//  EuskoEvents
//
//  Created by Ion Jaureguialzo Sarasola on 27/12/17.
//  Copyright © 2017 Asier. All rights reserved.
//

import UIKit

class CeldaTableViewCell: UITableViewCell {

    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var provincias: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
