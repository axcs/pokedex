//
//  HomeViewController.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//
import UIKit

class HomeViewController: ViewControllerUtil, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    private let viewModel = HomeViewModel()
    private var listaPoke: CommonListPokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
      
        
        self.showActivityIndicator()
        self.viewModel.getAllPokemons(limit: 10, offset: 0) { sucess, response in
            if sucess{
                self.listaPoke = response
                DispatchQueue.main.async {
                self.homeCollectionView.reloadData()
                    self.hideActivityIndicator()
            }
            }
        }
        
        
    }
    
    func setupCollectionView(){
        self.homeCollectionView.dataSource = self
        self.homeCollectionView.delegate = self
        self.homeCollectionView.register(cellType: PokeCollectionViewCell.self)
        
//        if let collectionViewLayout = homeCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            collectionViewLayout.estimatedItemSize = CGSize.init(width: 350, height: 350)
//        }
    }
    
    
    // MARK: collectionview delegate functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = listaPoke{
            return listaPoke?.results?.count ?? 0
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailsPokeViewController") as! DetailsPokeViewController
        if let pokemonObj = self.listaPoke?.results {
            vc.idP = pokemonObj[indexPath.row].id
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
        
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(with: PokeCollectionViewCell.self, for: indexPath)
        if let pokemonObj = self.listaPoke?.results {
            let pokemon = pokemonObj[indexPath.row]
            let name = pokemon.url
            let listItems = name.components(separatedBy: "/")
            self.viewModel.getPokemonInfo(index: listItems[6]) { sucess, response in


                var imageURL : String?
                if let sprites = response?.sprites {
                    if let sprite = sprites.other{
                        imageURL = sprite.officialartwork?.front_default
                    }else{
                        imageURL = sprites.front_default
                    }
                }
                var descriptionText = "#"
                if let id = response?.id{
                    let idStr = "\(id)"
                    descriptionText += idStr.addzeros
                    pokemon.id = "\(id)"
                }
                
                
               
                let viewModel = PokemonCollectionViewViewModel(id: pokemon.id, name: pokemon.name, description: descriptionText, imageURL: imageURL, favoriteAction: { (status :Bool, id: String) -> Void in
                        self.teste(status, id)
                        //                self.presenter?.updateFavoriteStatus(index: indexPath.row, favoriteStatus: status)
                    })
                DispatchQueue.main.async {
                    cell.setup(pokemon: viewModel)
                }
            }
        }
        return cell
        
    }
    
    func teste(_ status: Bool, _ id: String){
        viewModel.updateFavoriteStatus(index: id, favoriteStatus: status)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.homeCollectionView.frame.width, height: 0)
    }
    
    
}