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
    @IBOutlet weak var pokeViewImg: UIView!
    @IBOutlet weak var pokeImageView: UIImageView!
    @IBOutlet weak var numberLB: UILabel!
    @IBOutlet weak var numberLBtxt: UILabel!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var pokeInfo: UIView!
    @IBOutlet weak var heightLB: UILabel!
    @IBOutlet weak var heightLBtxt: UILabel!
    @IBOutlet weak var weightLB: UILabel!
    @IBOutlet weak var weightLBtxt: UILabel!
    @IBOutlet weak var typeLB: UILabel!
    @IBOutlet weak var typeLBtxt: UILabel!
    @IBOutlet weak var descLb: UILabel!
    @IBOutlet weak var statusTableView: UITableView!
    
    //MARK: - Var
    private let detailCellIdentifier = "statsViewCell"
    private let headerCellIdentifier = "headerStatsViewCell"
    private var status: [StatsModel]?
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
        loadSerices()
    }
    
    
    //MARK: -  Func
    func tableLoad(){
        statusTableView.dataSource = self
        statusTableView.delegate = self
        statusTableView.register(UINib(nibName: "StatsViewCell", bundle: nil), forCellReuseIdentifier: detailCellIdentifier)
    }
    
    func loadInfoForView(){
        
        //BTN_close Layout
        btnClose.layer.shadowColor = UIColor.black.cgColor
        btnClose.layer.shadowOffset = CGSize(width: 6, height: 10)
        btnClose.layer.shadowOpacity = 0.2
        btnClose.layer.shadowRadius = 5.0
        
        //PokeViewImg Layout
        // border
        pokeViewImg.layer.borderWidth = 1.2
        pokeViewImg.layer.borderColor = UIColor.gray.cgColor
        pokeViewImg.layer.cornerRadius = 15
        // shadow
        pokeViewImg.layer.shadowColor = UIColor.black.cgColor
        pokeViewImg.layer.shadowOffset = CGSize(width: 6, height: 10)
        pokeViewImg.layer.shadowOpacity = 0.4
        pokeViewImg.layer.shadowRadius = 5.0
        
        //pokeInfo Layout
        // border
        pokeInfo.layer.borderWidth = 1.2
        pokeInfo.layer.borderColor = UIColor.gray.cgColor
        pokeInfo.layer.cornerRadius = 15
        // shadow
        pokeInfo.layer.shadowColor = UIColor.black.cgColor
        pokeInfo.layer.shadowOffset = CGSize(width: 6, height: 10)
        pokeInfo.layer.shadowOpacity = 0.4
        pokeInfo.layer.shadowRadius = 5.0
        
    }
    
    func loadSerices(){
        self.showActivityIndicator()   // Show spinner loading
        
        self.viewModel.getPokemonInfo(id: pokeID) { success, response in
            if success {
                self.numberLBtxt.text = response?.pokemon?.description
                self.nameTxt.text = response?.pokemon?.name
                self.heightLBtxt.text = response?.pokemon?.weight
                self.weightLBtxt.text = response?.pokemon?.height
                self.status = response?.pokemon?.stats
                self.statusTableView.reloadData()
                self.typeLBtxt.text = response?.pokemon?.types
                if let imgURL = response?.pokemon?.imageURL {
                    self.pokeImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.pokeImageView.sd_setImage(with: URL(string: imgURL))
                }else{
                    self.pokeImageView.image = UIImage(named: "pokebola")
                }
            }
            else {
                "Erro getPokemonInfo".errorLog()
            }
            
            self.viewModel.getPokemonSpecies(id: self.pokeID) { success, response in
                if success {
                    let pokemonFlavor = response?.species?.flavorText
                    DispatchQueue.main.async {
                        self.descLb.text = pokemonFlavor
                        self.hideActivityIndicator()   // hide spinner loading
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier)
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return status?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: detailCellIdentifier, for: indexPath) as! StatsViewCell
        cell.txtTitle = status?[indexPath.row].stat?.name?.firstCapitalized
        cell.val1 = "\(status?[indexPath.row].base_stat ?? 0)"
        cell.val2 = "\(status?[indexPath.row].effort ?? 0)"
        return cell
    }
}
