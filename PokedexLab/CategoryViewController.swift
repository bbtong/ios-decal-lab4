//
//  CategoryViewController.swift
//  PokedexLab
//
//  Created by SAMEER SURESH on 2/25/17.
//  Copyright © 2017 iOS Decal. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var pokemonArray: [Pokemon]?
    var cachedImages: [Int:UIImage] = [:]
    var selectedIndexPath: IndexPath?
    
    
    /* tableView function for # of rows in the section. */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "tableViewCellID", for: indexPath) as! customTableViewCell
        let pokemon = pokemonArray![indexPath.row]
        if let image = cachedImages[indexPath.row] {
            cell.pokemonImage.image = image // may need to change this!
        } else {
            let url = URL(string: pokemon.imageUrl)!
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                if let e = error {
                    print("Error downloading picture: \(e)")
                } else {
                    if let _ = response as? HTTPURLResponse {
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            self.cachedImages[indexPath.row] = image
                            cell.pokemonImage.image = UIImage(data: imageData) // may need to change this!
                            
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code")
                    }
                }
            }
            downloadPicTask.resume()
        }
        cell.pokeName.text = pokemon.name
        let atk = String(pokemon.attack)
        let def = String(pokemon.defense)
        let hp = String(pokemon.health)
        let stats = atk + "/" + def + "/" + hp
        let numba = String(pokemon.number)
        cell.pokeNumber.text = "#" + numba
        cell.pokeStats.text = stats
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "categoryToPokemon", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "categoryToPokemon" {
                if let dest = segue.destination as? PokemonInfoViewController {
                    dest.image = cachedImages[(selectedIndexPath?.row)!]
                    dest.pokemon = pokemonArray![(selectedIndexPath?.row)!] // ???
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //pokemonArray = PokemonGenerator.getPokemonArray()
        myTableView.delegate = self
        myTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
