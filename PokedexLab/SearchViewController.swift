//
//  SearchViewController.swift
//  PokedexLab
//
//  Created by SAMEER SURESH on 2/25/17.
//  Copyright © 2017 iOS Decal. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var pokemonArray: [Pokemon] = []
    var filteredArray: [Pokemon] = []
    
    /* My collection view outlet. */
    @IBOutlet weak var myCollectionViewCell: UICollectionView!
    
    /* CollectonView function for # of items in the section. */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //PokemonGenerator.categoryDict[/* some int */]
        //return 10
        //return pokemonArray.count // is this correct?
        return PokemonGenerator.categoryDict.count
    }
    
    /* CollectonView function to get the cell for the item at index: IndexPath. */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemonViewIdentifier", for: indexPath) as! customCollectionViewCell
        let pokeCategory = (PokemonGenerator.categoryDict[indexPath.item])
        myCell.myImageView.image = UIImage(named: pokeCategory!)
        return myCell
    }
    
    /* CollectonView function to get the cell for the item at index: IndexPath. */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filteredArray = filteredPokemon(ofType: indexPath.item)
        performSegue(withIdentifier: "searchToCategory", sender: self) // fix this
    }

    // fix dis
    /* add the prepareForSegue method to the SearchViewController, and set the pokemonArray variable in the destination view controller (segue.destination) to your filtered array. (If you're having trouble at this step, check out the prepare for segue example in Lecture 3)*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "searchToCategory" {
                if let dest = segue.destination as? CategoryViewController {
                    dest.pokemonArray = filteredArray
                }
            }
        }
        /*else if identifier == "categoryToPokemon" {
            if let dest = segue.destination as? PokemonInfoViewController {
                
            }
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonArray = PokemonGenerator.getPokemonArray()
        myCollectionViewCell.delegate = self
        myCollectionViewCell.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Utility function to iterate through pokemon array for a single category
    func filteredPokemon(ofType type: Int) -> [Pokemon] {
        var filtered: [Pokemon] = []
        for pokemon in pokemonArray {
            if (pokemon.types.contains(PokemonGenerator.categoryDict[type]!)) {
                filtered.append(pokemon)
            }
        }
        return filtered
    }


}
