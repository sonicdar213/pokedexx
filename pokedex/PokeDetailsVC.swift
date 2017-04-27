//
//  PokeDetailsVC.swift
//  pokedex
//
//  Created by Truong Son Nguyen on 4/17/17.
//  Copyright © 2017 Truong Son Nguyen. All rights reserved.
//

import UIKit

class PokeDetailsVC: UIViewController {
    var pokemon:Pokemon!
    
    @IBOutlet weak var mainImg: UIImageView!
    
    @IBOutlet weak var dectionlbl: UILabel!
    
  
    @IBOutlet weak var heilbl: UILabel!
    @IBOutlet weak var typelbl: UILabel!
    
    @IBOutlet weak var defencelbl: UILabel!
    @IBOutlet weak var weilbl: UILabel!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var pokedexidlbl: UILabel!
   
    @IBOutlet weak var currentImg: UIImageView!
    
    @IBOutlet weak var Evlabel: UILabel!
    @IBOutlet weak var baseATK: UILabel!
    @IBOutlet weak var nextcurrentImg: UIImageView!
    
    @IBAction func backBtnpressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentImg.image = img
        pokedexidlbl.text = "\(pokemon.pokedexId)"
        namelbl.text = pokemon.name
        pokemon.downloadPokemonDetails { 
            //Whatever you write will only be called after the network call is complete
            self.updateUI()
            print("Did Arrive here ")
        }
    }
    func updateUI() {
        baseATK.text = pokemon.attack
        defencelbl.text = pokemon.defense
        heilbl.text = pokemon.height
        weilbl.text = pokemon.weight
        typelbl.text = pokemon.type
        dectionlbl.text = pokemon.desction
    
        if pokemon.nextEvolutionsID == "" {
            Evlabel.text = "No Evolution"
            nextcurrentImg.isHidden = true
        } else {
            
            nextcurrentImg.isHidden = false
            nextcurrentImg.image = UIImage(named:pokemon.nextEvolutionsID)
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - Lvl \(pokemon.nextapp)"
            Evlabel.text = str
        }
        
        
    }
}

  


