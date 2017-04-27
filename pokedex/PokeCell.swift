//
//  PokeCell.swift
//  pokedex
//
//  Created by Truong Son Nguyen on 4/14/17.
//  Copyright © 2017 Truong Son Nguyen. All rights reserved.
//

import UIKit
import Alamofire
class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var namelbl : UILabel!
    
    var pokemon:Pokemon!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    func ConfigureCell( _ pokemon:Pokemon!) {
        self.pokemon = pokemon
        namelbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: String(self.pokemon.pokedexId))
    }
    
}
