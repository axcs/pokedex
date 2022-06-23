//
//  HomeViewController.swift
//  Pokedex
//
//  Created by axavierc on 21/06/2022.
//
import UIKit

class HomeViewController: ViewControllerUtil {
    //MARK: - Outlets
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    //MARK: - Var
    private let viewModel = HomeViewModel()
    private var listaPoke: [Resultt] = []
    private var pageOffset:Int = 0          // var count offset Page
    private var pageRowsLimite:Int = 10      // var page limite
    private var isLoading:Bool = false      // var for loading state in load more
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.callInicialService()
    }
    
    
    //MARK: -  Func
    func setupCollectionView(){
        self.homeCollectionView.dataSource = self
        self.homeCollectionView.delegate = self
        self.homeCollectionView.register(cellType: PokeCollectionViewCell.self)
    }
    
    
    func callInicialService(){
        self.showActivityIndicator()   // Show spinner loading
        self.viewModel.getAllPokemons(limit: pageRowsLimite, offset: pageOffset) { success, response in
            if success{
                self.listaPoke = response?.results ?? []
                DispatchQueue.main.async {
                    self.homeCollectionView.reloadData()
                    self.hideActivityIndicator()   // hide spinner loading
                }
            }
            else {
                "Error on GetAllPokemons Service".errorLog()
                self.showError(msg: "Error on GetAllPokemons Service")
            }
        }
    }
    
    func favoriteClick(_ status: Bool, _ id: String){
        self.viewModel.updateFavoriteStatus(idPokemon: id, favoriteStatus: status) { success in
       
            if success {
                self.showMsg(msg: "Favorite sent successfully!")
            }
            else{
                self.showError(msg: "Error sending favorite")
            }
            
        }
    }
    
    func loadMorePages(){
        pageOffset += 10
        self.viewModel.getAllPokemons(limit: 10, offset: pageOffset) { sucess, response in
            if sucess{
                self.listaPoke += response?.results ?? []
                self.isLoading = false
                DispatchQueue.main.async {
                    self.homeCollectionView.reloadData()
                    self.hideActivityIndicator()
                }
            }
        }
    }
    
}

///MARK: - UICollection Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaPoke.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detailsPokeViewController") as! DetailsPokeViewController
        vc.idP = self.listaPoke[indexPath.row].idAux
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(with: PokeCollectionViewCell.self, for: indexPath)
        let pokemon = self.listaPoke[indexPath.row]
        let name = pokemon.url
        let listItems = name.components(separatedBy: "/")
        self.viewModel.getPokemonInfo(index: listItems[6]) { success, response in
            if success{
                pokemon.idAux = response?.pokemon?.id
                let viewModel = PokemonCollectionViewViewModel(id: response?.pokemon?.id, name: response?.pokemon?.name, description: response?.pokemon?.description ?? "", imageURL: response?.pokemon?.imageURL, favoriteAction: { (status :Bool, id: String) -> Void in
                    self.favoriteClick(status, id)
                })
                DispatchQueue.main.async {
                    cell.setup(pokemon: viewModel)
                }
            }else {
                "Error on getPokemonInfo Service".errorLog()
                self.showError(msg: "Error on getPokemonInfo Service")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.homeCollectionView.frame.width, height: 0)
    }
}

///MARK: - Scrollview Delegate
extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((homeCollectionView.contentOffset.y + homeCollectionView.frame.size.height) >= homeCollectionView.contentSize.height)
        {
            if scrollView.contentOffset.y  > 0{
                if isLoading == false {
                    self.showActivityIndicator()
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        self.loadMorePages()
                    }
                }
            }
        }
    }
}
