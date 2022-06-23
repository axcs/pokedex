//
//  DetailsPokeViewController.swift
//  Pokedex
//
//  Created by axavierc on 22/06/2022.
//

import UIKit
import SDWebImage

class DetailsPokeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let detailCellIdentifier = "statsViewCell"
    
    @IBOutlet weak var pokeViewImg: UIView!
    @IBOutlet weak var pokeImageView: UIImageView!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var pokeInfo: UIView!
    
    @IBOutlet weak var heightLB: UILabel!
    @IBOutlet weak var heightLBtxt: UILabel!
    
    
    @IBOutlet weak var weightLB: UILabel!
    @IBOutlet weak var weightLBtxt: UILabel!
    
    @IBOutlet weak var typeLB: UILabel!
    @IBOutlet weak var typeLBtxt: UILabel!
    
    @IBOutlet weak var statusTableView: UITableView!

    var status: [CDLStatsModel]?
    
    
    private let viewModel = DetailsPokeViewModel()
    
    
    //MARK: - Var
     private var pokeID: String!
 
    
    var idP: String? {
      didSet {
          pokeID = idP
      }
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        loadInfoForView()
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func loadInfoForView(){
        statusTableView.dataSource = self
        statusTableView.delegate = self
        statusTableView.register(UINib(nibName: "StatsViewCell", bundle: nil), forCellReuseIdentifier: detailCellIdentifier)
   
        
        btnClose.layer.shadowColor = UIColor.black.cgColor
        btnClose.layer.shadowOffset = CGSize(width: 6, height: 10)
        btnClose.layer.shadowOpacity = 0.2
        btnClose.layer.shadowRadius = 5.0
        
        
        
        pokeViewImg.layer.cornerRadius = 15
        
        // border
        pokeViewImg.layer.borderWidth = 1.2
        pokeViewImg.layer.borderColor = UIColor.gray.cgColor
        // shadow
        pokeViewImg.layer.shadowColor = UIColor.black.cgColor
        pokeViewImg.layer.shadowOffset = CGSize(width: 6, height: 10)
        pokeViewImg.layer.shadowOpacity = 0.4
        pokeViewImg.layer.shadowRadius = 5.0
 
        
        
        pokeInfo.layer.cornerRadius = 15
        
        // border
        pokeInfo.layer.borderWidth = 1.2
        pokeInfo.layer.borderColor = UIColor.gray.cgColor
        // shadow
        pokeInfo.layer.shadowColor = UIColor.black.cgColor
        pokeInfo.layer.shadowOffset = CGSize(width: 6, height: 10)
        pokeInfo.layer.shadowOpacity = 0.4
        pokeInfo.layer.shadowRadius = 5.0
        
        
        
        
        self.viewModel.getPokemonInfo(index: pokeID) { sucess, pokemon in
            
            let weight = Double(pokemon?.weight ?? 0)
            let height = Double(pokemon?.height ?? 0)
            
            self.nameTxt.text = (pokemon?.name)?.firstCapitalized
         
            self.heightLBtxt.text = "\(height / 10.0) m"
            self.weightLBtxt.text = "\(weight / 10.0) kg"
            
            self.status = pokemon?.stats
            self.statusTableView.reloadData()
            
            
            var types: String = ""
            for item in pokemon?.types ?? [] {
                types += (item.type?.name)?.firstCapitalized ?? ""
                types += "; "
            }
            self.typeLBtxt.text = types
            
            var imageURL : String?
            if let sprites = pokemon?.sprites {
                if let sprite = sprites.other{
                    imageURL = sprite.officialartwork?.front_default
                }else{
                    imageURL = sprites.front_default
                }
            }
            
            if let imgURL = imageURL {
                self.pokeImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.pokeImageView.sd_setImage(with: URL(string: imgURL))
            }else{
                self.pokeImageView.image = UIImage(named: "poke_icon")
            }
            
        }
            
    }
    

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerStatsViewCell") as! HeaderStatsViewCell
//
//        return headerView
//    }
//
//    nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
//
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
//        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerStatsViewCell")
//               headerView.addSubview(headerCell)
        return headerCell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "headerStatsViewCell", for: section) as! HeaderStatsViewCell
//
//
//        return cell
    }
    
//    // Create a standard header that includes the returned text.
//     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//       return "Header \(section)"
//    }


    
    
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
