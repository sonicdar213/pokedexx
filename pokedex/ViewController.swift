//
//  ViewController.swift
//  pokedex
//
//  Created by Truong Son Nguyen on 4/13/17.
//  Copyright © 2017 Truong Son Nguyen. All rights reserved.
//

import UIKit
import AVFoundation


//Delegate = We will be making changes on behalf of the UIView , Datasource = this is where data will originate, DelegateFlowLayout = Modify and set layout for collection view


//SearchbarDelegate 
class ViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , UISearchBarDelegate {
    @IBOutlet weak var collection: UICollectionView!
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    var music : AVAudioPlayer!
    
    @IBOutlet weak var search: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        search.delegate = self
        parsePokemonCSV()
        initAudio()
        search.returnKeyType = UIReturnKeyType.done
        // Do any additional setup after loading the view, typically from a nib.
    }
    func initAudio(){
        let path = Bundle.main.path(forResource: "GameOfThrones-MainThemeOfficialS_3x4vq", ofType: "mp3")
        do {
            music = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            music.prepareToPlay()
            music.numberOfLoops = -1
            music.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        }
    func parsePokemonCSV() {
        let path =  Bundle.main.path(forResource: "pokemon", ofType: "csv")
        do {
            let csv = try CSV(contentsOfURL: path!)
            let row  = csv.rows
//            print(row)
        
            for row in row {
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexID: pokeID)
                pokemon.append(poke)
            }
            
            
        } catch let err as NSError  {
            print(err.debugDescription)
        }
        
    }
    //DEQUES THE CELLS AND SETS THEM UP
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //deques reusable cell loads the exact number of items to be displayed at a time . Else, return the empty cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath) as? PokeCell {
            //Each time the cell is called
            let poke : Pokemon!
            if inSearchMode {
          poke = filteredPokemon[indexPath.row]
            cell.ConfigureCell(poke)
            } else {
                //Receives the data from the configure cell funtion that we've created before from the pokecell  page
                poke = pokemon[indexPath.row]
                cell.ConfigureCell(poke)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke : Pokemon!
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        performSegue(withIdentifier: "PokeDetailsVC", sender: poke )

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
        } else {
            return pokemon.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
   //Turn music on or off
    
    @IBAction func iconBtnpressed(_ sender: UIButton) {
        if music.isPlaying {
            music.pause()
            sender.alpha = 0.2
        } else {
            music.play()
            sender.alpha = 1.0
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    //search bar function based on the changing text.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //IF nil or empty then we are not in search mode
        if search.text == nil  || search.text == "" {
            inSearchMode = false
            collection.reloadData()
        } else {
            inSearchMode = true
            //Reloads the original list of data
            let lower = search.text!.lowercased()
            //the $0 is a place holder. This says that if the name is we typed is in original list , then place it on the filtered list
            filteredPokemon = pokemon.filter({$0.name.range(of:lower) != nil})
            collection.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokeDetailsVC" {
            if let detailsVC = segue.destination as? PokeDetailsVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke    
                }
            }
        }
    }
}


