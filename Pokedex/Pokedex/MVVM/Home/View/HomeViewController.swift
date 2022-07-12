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
    @IBOutlet weak var homeTitleLB: UILabel!

    //MARK: - Var
    private let viewModel = HomeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupCollectionView()
        self.fetchPokemonList()
    }
    
    //MARK: -  Func
    func setupView() {
        self.bindToModel()
        self.homeTitleLB.text = "titleHome".localized
    }

    func setupCollectionView(){
        self.homeCollectionView.dataSource = self
        self.homeCollectionView.delegate = self
        self.homeCollectionView.register(cellType: PokeCollectionViewCell.self)
    }
}


extension HomeViewController {
    
    func fetchPokemonList(){
        self.showActivityIndicator()
        self.viewModel.fetchAllPokemons()
    }
    
    
    func bindToModel() {
        viewModel.error.bind { error in
            DispatchQueue.main.async {
                AlertView.instance.showAlert(title: "g_error".localized, message: error, alertType: .failure, buttonTitle: "g_ok".localized)
            }
        }
        
        viewModel.model.bind { value in
            self.reloadTableView()
            self.hideActivityIndicator()
            self.isLoading = false
        }
        
        viewModel.saveFavoritsModel.bind { value in
            DispatchQueue.main.async {
                AlertView.instance.showAlert(title: "g_sucesso".localized, message: "favMsg".localized, alertType: .success, buttonTitle: "g_ok".localized)
                
            }
        }
        
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.homeCollectionView.reloadData()
        }
    }
}


///MARK: - UICollection Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.model.value?.listPokemons.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let pokemon = viewModel.model.value?.listPokemons[indexPath.row]
        let vc = storyboard.instantiateViewController(withIdentifier: "detailsPokeViewController") as! DetailsPokeViewController
        vc.idP = pokemon?.numPoke
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(with: PokeCollectionViewCell.self, for: indexPath)
        let pokemon = viewModel.model.value?.listPokemons[indexPath.row]
      
        let viewModel = PokemonCollectionViewViewModel(id: pokemon?.numPoke, name: pokemon?.name, description: pokemon?.pokemonInfo?.description ?? "", imageURL: pokemon?.pokemonInfo?.imageURL, favoriteAction: { (status :Bool, id: String) -> Void in
            self.viewModel.saveFavorits(id: id)
          
        })
        DispatchQueue.main.async {
            cell.setup(pokemon: viewModel)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.homeCollectionView.frame.width, height: 0)
    }
}

///MARK: - Scrollview Delegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset) <= 10 {
            if self.isLoading == false {
                self.showActivityIndicator()
                self.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.viewModel.fetchNextPagePokemons()
                }
            }
        }
    }
}
