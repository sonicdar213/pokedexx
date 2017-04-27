    //
    //  Pokemon.swift
    //  pokedex
    //
    //  Created by Truong Son Nguyen on 4/14/17.
    //  Copyright © 2017 Truong Son Nguyen. All rights reserved.
    //

    import Foundation
    import Alamofire
    class Pokemon {
        private var _name:String!
        private var _pokedexID:Int!
        private var _desction:String!
        private var _type:String!
        private var _defense:String!
        private var _height:String!
        private var _weight:String!
        private var _attack:String!
        private var _lbltxt:String!
        private var _nextEvolutionsName:String!
        private var _nextEvolutionsID:String!
        private var _nextEvolutionsLvl:String!
        private var _pokedex:String!
        private var _pokemonURL:String!
        
        var nextapp:String {
            if _nextEvolutionsLvl == nil {
                _nextEvolutionsLvl = ""
            }
            return _nextEvolutionsLvl
        }
        
        var nextEvolutionsID:String {
            if _nextEvolutionsID == nil {
                _nextEvolutionsID = ""
            }
            return _nextEvolutionsID
        }
        
        var nextEvolutionName:String {
            if _nextEvolutionsName == nil {
                _nextEvolutionsName = ""
            }
            return _nextEvolutionsName
        }
        
        var desction:String {
            if _desction == nil {
                return ""
            }
            return _desction
        }
        var type:String {
            if _type == nil {
                return ""
            }
            return _type
        }
        var defense:String {
            if _defense == nil {
                return ""
            }
            return _defense
        }
        var weight:String{
            if _weight == nil {
                return ""
            }
            return _weight
        }
        var height:String{
            if _height == nil {
                return ""
            }
            return _height
        }
        var attack : String {
            if _attack == nil {
                return ""
            }
            return _attack
        }
        var nextEvolutionText:String {
            if _lbltxt == nil {
                return ""
            } else {
                return _lbltxt
            }
        }
        var name:String {
            return _name
            
        }
        var pokedexId:Int {
            return _pokedexID
        }
        init(name:String , pokedexID:Int) {
            self._name = name
            self._pokedexID = pokedexID
            self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
        }
        func downloadPokemonDetails(completed: @escaping downloadComplete){
            
            print(_pokemonURL)
            
            Alamofire.request(_pokemonURL!, method: .get).responseJSON {response in
                print(response.result.value!)
                
                if let dict = response.result.value as? Dictionary<String,AnyObject> {
                    if let weight = dict["weight"] as? String {
                        self._weight = weight
                    }
                    
                    if let height =  dict["height"] as? String{
                        self._height = height
                    }
                    
                    if let attack = dict["attack"] as? Int{
                        self._attack = "\(attack)"
                    }
                    
                    if let defence = dict["defense"] as? Int{
                        self._defense = "\(defence)"
                    }
                    
                    print(self._defense)
                    print(self._height)
                    print(self._attack)
                    
                    if let types = dict["types"] as? [Dictionary<String,String>], types.count>0 {
                        if let name = types[0]["name"] {
                            self._type = name.capitalized
                        }
                        if types.count > 1 {
                            for x in 1..<types.count {
                                if let name = types[x]["name"] {
                                    self._type! += "/\(name.capitalized)"
                                }
                            }
                        }
                        print(self._type)
                        
                    } else {
                        self._type = ""
                    }
                    if let descArr = dict["descriptions"] as? [Dictionary<String,String>], descArr.count > 0 {
                        if let url = descArr[0]["resource_uri"]{
                            let descURL = "\(URL_BASE)\(url)"
                            Alamofire.request(descURL,method:.get).responseJSON(completionHandler: {(response) in
                                if let descDict = response.result.value as? Dictionary<String,AnyObject> {
                                    if let description = descDict["description"] as? String {
                                        let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                        self._desction = newDescription
                                        print(newDescription)
                                        
                                    }
                                    
                                }
                                completed()
                            })
                            
                        }
                    } else {
                        self._desction = "Date was nil"
                    }
                    if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>], evolutions.count>0 {
                        
                        if let nextEvolutions = evolutions[0]["to"] as? String {
                            
                            if nextEvolutions.range(of: "mega") == nil {
                                
                                self._nextEvolutionsName = nextEvolutions
                                
                                if let uri = evolutions[0]["resource_uri"] as? String {
                                    
                                    let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                    
                                    let nextEvoID = newStr.replacingOccurrences(of: "/", with: "")
                                    
                                    self._nextEvolutionsID = nextEvoID
                                    
                                    if let levelexist = evolutions[0]["level"] {
                                        
                                        if let lvl = levelexist as? Int {
                                            
                                            self._nextEvolutionsLvl = "\(lvl)"
                                        }
                                    } else {
                                        self._nextEvolutionsLvl = ""
                                    }
                                    
                                }
                                
                            }
                        }
                        print(self.nextEvolutionsID)
                        print(self.nextEvolutionName)
                        print(self.nextapp)
                    }
                }
                completed()
            }
            
        }
        
    }
