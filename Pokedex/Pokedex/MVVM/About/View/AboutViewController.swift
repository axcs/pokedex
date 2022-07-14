//
//  AboutViewController.swift
//  Pokedex
//
//  Created by axavierc on 13/07/2022.
//

import UIKit

class AboutViewController: ViewControllerUtil{
    
    //MARK: - Outlets
    @IBOutlet weak var iconAppView: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var versionLB: UILabel!
    @IBOutlet weak var developedByLB: UILabel!
    @IBOutlet weak var weightBtn1: RadioButton!
    @IBOutlet weak var weightBtn2: RadioButton!
    @IBOutlet weak var heightBtn1: RadioButton!
    @IBOutlet weak var heightBtn2: RadioButton!
    
    @IBOutlet weak var unitsLB: UILabel!
    @IBOutlet weak var heightLB: UILabel!
    @IBOutlet weak var weightLB: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       initViewUI()
       loadValues()
    }
    
    func initViewUI(){
        iconAppView.layer.cornerRadius = 21
        btnClose.layer.shadowColor = UIColor.black.cgColor
        btnClose.layer.shadowOffset = CGSize(width: 6, height: 10)
        btnClose.layer.shadowOpacity = 0.2
        btnClose.layer.shadowRadius = 5.0
        
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        self.versionLB.text = "\("about_appVersion".localized) \(version) (\(build))"
        self.developedByLB.text = "\("about_appDeveloped".localized ) Alexandre Carvalho"
        self.heightLB.text = "about_height".localized
        self.heightLB.text = "about_weight".localized
        self.unitsLB.text = "about_units".localized
        
        weightBtn1?.alternateButton = [weightBtn2!]
        weightBtn2?.alternateButton = [weightBtn1!]
        
        heightBtn1?.alternateButton = [heightBtn2!]
        heightBtn2?.alternateButton = [heightBtn1!]
    }
    
    
    
    func loadValues() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: USER_SETTINGS_WEIGHT){
            weightBtn1.isSelected = false
            weightBtn2.isSelected = true
        }
        else {
            weightBtn1.isSelected = true
            weightBtn2.isSelected = false
        }
        
        if defaults.bool(forKey: USER_SETTINGS_HEIGHT){
            heightBtn1.isSelected = false
            heightBtn2.isSelected = true
        }
        else {
            heightBtn1.isSelected = true
            heightBtn2.isSelected = false
        }
        
    }
    
    //MARK: -  IbActions Btn
    @IBAction func btnCloseAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func weightAction(_ sender: RadioButton) {
        let defaults = UserDefaults.standard
        if sender == weightBtn1{
            defaults.set(false, forKey: USER_SETTINGS_WEIGHT)
        }
        else {
            defaults.set(true, forKey: USER_SETTINGS_WEIGHT)
        }
    }
    
    @IBAction func heightAction(_ sender: RadioButton) {
        let defaults = UserDefaults.standard
        if sender == heightBtn1{
            defaults.set(false, forKey: USER_SETTINGS_HEIGHT)
        }
        else {
            defaults.set(true, forKey: USER_SETTINGS_HEIGHT)
        }
        
    }
    
}
