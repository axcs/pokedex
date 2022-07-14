//
//  DetailsPokeViewController.swift
//  Pokedex
//
//  Created by axavierc on 22/06/2022.
//

import UIKit

class DetailsPokeViewController: ViewControllerUtil{
    
    //MARK: - Outlets
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var statusTableView: UITableView!
    @IBOutlet weak var logoBackground: UIView!
    
    //MARK: - Var
    private let STATS_CELL_IDENT = "statsViewCell"
    private let INFO_CELL_IDENT = "infoPokemonCell"
    private let HEADER_POKEMON_CELL_IDENT = "headerPokemonCell"
    private let HEADER_INFO_CELL_IDENT = "section1Cell"
    private let HEADER_STATS_CELL_IDENT = "section2Cell"
    
    private let viewModel = DetailsPokeViewModel()
    private var pokeID: String!
    
    var idP: String? {
        didSet {
            pokeID = idP
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadInfoForView()
        tableLoad()
        loadServices()
        bindToModel()
    }
    
    
    //MARK: -  Func
    func tableLoad(){
        statusTableView.dataSource = self
        statusTableView.delegate = self
        statusTableView.register(HeaderPokemonCell.self, forCellReuseIdentifier: HEADER_POKEMON_CELL_IDENT)
        statusTableView.register(StatsViewCell.self, forCellReuseIdentifier: STATS_CELL_IDENT)
        statusTableView.register(InfoPokemonCell.self, forCellReuseIdentifier: INFO_CELL_IDENT)
        statusTableView.register(Section1Cell.self, forCellReuseIdentifier: HEADER_INFO_CELL_IDENT)
        statusTableView.register(Section2Cell.self, forCellReuseIdentifier: HEADER_STATS_CELL_IDENT)
    }
    
    func loadInfoForView(){
        //BTN_close Layout
        
        
        
        //        logoBackground.rotate()
        btnClose.layer.shadowColor = UIColor.black.cgColor
        btnClose.layer.shadowOffset = CGSize(width: 6, height: 10)
        btnClose.layer.shadowOpacity = 0.2
        btnClose.layer.shadowRadius = 5.0
    }
    
    //MARK: -  IbActions Btn
    @IBAction func btnCloseAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailsPokeViewController {
    
    func loadServices(){
        self.showActivityIndicator()
        viewModel.fetchPokemonInfo(idP ?? "")
    }
    
    private func bindToModel() {
        // Set View Model Event Listener
        viewModel.model.bind {value in
            self.nameTxt.text = value.pokemon?.name
        }
        
        viewModel.sectionOneData.bind {value in
            DispatchQueue.main.async {
                self.statusTableView.reloadData()
                self.hideActivityIndicator()
                self.logoBackground.rotate()
            }
        }
        
        viewModel.saveFavoritsModel.bind { value in
            self.hideActivityIndicator()
            if value.success {
                DispatchQueue.main.async {
                    AlertView.instance.showAlert(title: "g_success".localized, message: "favMsg".localized, alertType: .success, buttonTitle: "g_ok".localized)
                }
            }
        }
        
        viewModel.error.bind {error in
            DispatchQueue.main.async {
                AlertView.instance.showAlert(title: "g_error".localized, message: error, alertType: .failure, buttonTitle: "g_ok".localized)
            }
        }
    }
}

///MARK: - UICollection Delegate
extension DetailsPokeViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 255
        } else {
            return 32
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let lb = UILabel()
            lb.text = ""
            return lb
        case 1:
            let header = tableView.dequeueReusableCell(withIdentifier: HEADER_STATS_CELL_IDENT) as! Section2Cell
            return header
        case 2:
            let header = tableView.dequeueReusableCell(withIdentifier: HEADER_INFO_CELL_IDENT) as! Section1Cell
            return header
        default:
            let lb = UILabel()
            lb.text = ""
            return lb
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.sectionOneData.value?.count ?? 0
        case 2:
            return viewModel.model.value?.pokemon?.stats?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HEADER_POKEMON_CELL_IDENT, for: indexPath) as! HeaderPokemonCell
            let viewMo =   HeaderPokemonCellViewModel(id: viewModel.model.value?.pokemon?.id, description: viewModel.introData.value?.flavorText ?? "", imageURL: viewModel.model.value?.pokemon?.imageURL, favoriteAction:  {( id: String) -> Void in
                self.showActivityIndicator()
                self.viewModel.saveFavorits(id: id)
            })
            
            DispatchQueue.main.async {
                cell.setup(headerPokemon: viewMo)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: INFO_CELL_IDENT, for: indexPath) as! InfoPokemonCell
            let descAux = viewModel.sectionOneData.value?[indexPath.row].desc
            cell.txtTitle = descAux
            cell.val1 = viewModel.sectionOneData.value?[indexPath.row].value
            if (descAux == "detail_types".localized){
                cell.val1Label.changeColor()
            }
            
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: STATS_CELL_IDENT, for: indexPath) as! StatsViewCell
            cell.txtTitle = viewModel.model.value?.pokemon?.stats?[indexPath.row].stat?.name?.firstCapitalized
            cell.val1 = "\(viewModel.model.value?.pokemon?.stats?[indexPath.row].base_stat ?? 0)"
            cell.val2 = "\(viewModel.model.value?.pokemon?.stats?[indexPath.row].effort ?? 0)"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: INFO_CELL_IDENT, for: indexPath) as! InfoPokemonCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 32
    }
}
