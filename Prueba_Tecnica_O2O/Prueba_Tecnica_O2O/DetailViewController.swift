//
//  DetailViewController.swift
//  Prueba_Tecnica_O2O
//
//  Created by Jose M on 23/9/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    var titleBeer = ""
    var desc = ""
    var image_url = ""

    @IBOutlet weak var Beertitle: UILabel!
    @IBOutlet weak var BeerImage: UIImageView!
    @IBOutlet weak var BeerDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Beertitle.text = titleBeer
        BeerDescription.text = desc
        BeerImage.load(url: URL(string: image_url)!)
        
    }

}
