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
            let cell = tableView.dequeueReusableCell(withIdentifier: headerPokemonCellIdentifier, for: indexPath) as! HeaderPokemonCell
            if let imgUrl = viewModel.model.value?.pokemon?.imageURL {
                cell.imageViewPoke.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imageViewPoke.sd_setImage(with: URL(string: imgUrl))
            }else{
                cell.imageViewPoke.image = UIImage(named: "pokebola")
            }
            cell.descText = viewModel.introData.value?.flavorText
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifier, for: indexPath) as! InfoPokemonCell
            cell.txtTitle = viewModel.sectionOneData.value?[indexPath.row].desc
            cell.val1 = viewModel.sectionOneData.value?[indexPath.row].value
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailCellIdentifier, for: indexPath) as! StatsViewCell
            cell.txtTitle = viewModel.model.value?.pokemon?.stats?[indexPath.row].stat?.name?.firstCapitalized
            cell.val1 = "\(viewModel.model.value?.pokemon?.stats?[indexPath.row].base_stat ?? 0)"
            cell.val2 = "\(viewModel.model.value?.pokemon?.stats?[indexPath.row].effort ?? 0)"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifier, for: indexPath) as! InfoPokemonCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 32
    }
}
