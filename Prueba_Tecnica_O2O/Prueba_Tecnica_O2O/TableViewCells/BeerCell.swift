//
//  BeerCell.swift
//  Prueba_Tecnica_O2O
//
//  Created by Jose M on 21/9/22.
//

import UIKit

class BeerCell: UITableViewCell {
    
    
    @IBOutlet weak var BeerPrice: UILabel!
    @IBOutlet weak var BeerName: UILabel!
    @IBOutlet weak var BeerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
