//
//  DetailsPokeViewController.swift
//  Pokedex
//
//  Created by axavierc on 22/06/2022.
//

import UIKit
import SDWebImage

class DetailsPokeViewController: ViewControllerUtil{
    
    //MARK: - Outlets
    
    //    @IBOutlet weak var pokeImageView: UIImageView!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var statusTableView: UITableView!
    //    @IBOutlet weak var descTxt: UILabel!
    
    //MARK: - Var
    private let detailCellIdentifier = "statsViewCell"
    private let infoCellIdentifier = "infoPokemonCell"
    private let headerPokemonCellIdentifier = "headerPokemonCell"
    private let headerInfoIdentifier = "headerInfoViewCell"
    private let headerCellIdentifier = "headerStatsViewCell"
    private var status: [StatsModel]?
    private let viewModel = DetailsPokeViewModel()
    private var pokeID: String!
    private var descText: String = ""
    private var imgUrl: String = ""
    private var pokemonObj : [DescValueObj] = []
    
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
    }
    
    
    //MARK: -  Func
    func tableLoad(){
        statusTableView.dataSource = self
        statusTableView.delegate = self
        statusTableView.register(UINib(nibName: "HeaderPokemonCell", bundle: nil), forCellReuseIdentifier: headerPokemonCellIdentifier)
        statusTableView.register(UINib(nibName: "StatsViewCell", bundle: nil), forCellReuseIdentifier: detailCellIdentifier)
        statusTableView.register(UINib(nibName: "InfoPokemonCell", bundle: nil), forCellReuseIdentifier: infoCellIdentifier)
    }
    
    func loadInfoForView(){
        //BTN_close Layout
        btnClose.layer.shadowColor = UIColor.black.cgColor
        btnClose.layer.shadowOffset = CGSize(width: 6, height: 10)
        btnClose.layer.shadowOpacity = 0.2
        btnClose.layer.shadowRadius = 5.0
    }
    
    func loadServices(){
        self.showActivityIndicator()   // Show spinner loading
        var namePoke: String = ""
        self.viewModel.getPokemonInfo(id: pokeID) { success, response in
            if success {
                
                self.status = response?.pokemon?.stats
                
                let numberObj = DescValueObj(desc: "Number", value: response?.pokemon?.description ?? "")
                self.pokemonObj.append(numberObj)
                
                let weightObj = DescValueObj(desc: "Height", value: response?.pokemon?.weight ?? "")
                self.pokemonObj.append(weightObj)
                let heightObj = DescValueObj(desc: "Weight", value: response?.pokemon?.height ?? "")
                self.pokemonObj.append(heightObj)
                let typesObj = DescValueObj(desc: "Types", value: response?.pokemon?.types ?? "")
                self.pokemonObj.append(typesObj)
                
                self.imgUrl = response?.pokemon?.imageURL ?? ""
                namePoke = response?.pokemon?.name ?? ""
            }
            else {
                "Erro getPokemonInfo".errorLog()
            }
            
            self.viewModel.getPokemonSpecies(id: self.pokeID) { success, response in
                if success {
                    
                    DispatchQueue.main.async {
                        self.nameTxt.text = namePoke
                        self.descText = response?.species?.flavorText ?? ""
                        let typesObj = DescValueObj(desc: "Color", value: response?.species?.color?.name ?? "")
                        self.pokemonObj.append(typesObj)
                        self.hideActivityIndicator()   // hide spinner loading
                        self.statusTableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: -  IbActions Btn
    @IBAction func btnCloseAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

///MARK: - UICollection Delegate
extension DetailsPokeViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 32
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
            let headerCell = tableView.dequeueReusableCell(withIdentifier: headerInfoIdentifier)
            return headerCell
        case 2:
            let headerCell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier)
            return headerCell
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
            return pokemonObj.count
        case 2:
            return status?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: headerPokemonCellIdentifier, for: indexPath) as! HeaderPokemonCell
            
            if imgUrl != ""{
                cell.imageViewPoke.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imageViewPoke.sd_setImage(with: URL(string: imgUrl))
            }else{
                cell.imageViewPoke.image = UIImage(named: "pokebola")
            }
            cell.descText = descText
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifier, for: indexPath) as! InfoPokemonCell
            cell.txtTitle = pokemonObj[indexPath.row].desc
            cell.val1 = pokemonObj[indexPath.row].value
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailCellIdentifier, for: indexPath) as! StatsViewCell
            cell.txtTitle = status?[indexPath.row].stat?.name?.firstCapitalized
            cell.val1 = "\(status?[indexPath.row].base_stat ?? 0)"
            cell.val2 = "\(status?[indexPath.row].effort ?? 0)"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifier, for: indexPath) as! InfoPokemonCell
            return cell
            
        }
        
    }
}
