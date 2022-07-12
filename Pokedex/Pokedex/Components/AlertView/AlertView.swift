//
//  AlertView.swift
//  Pokedex
//
//  Created by axavierc on 12/07/2022.
//

import Foundation
import UIKit

class AlertView: UIView {
    
    static let instance = AlertView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        img.layer.cornerRadius = 30
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 2
        doneBtn.layer.cornerRadius = 10
        alertView.layer.cornerRadius = 10
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 100)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    enum AlertType {
        case success
        case failure
    }
    
    func showAlert(title: String, message: String, alertType: AlertType, buttonTitle: String) {
        parentView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        alertView.alpha = 0
        self.titleLbl.text = title
        self.messageLbl.text = message
        self.doneBtn.setTitle(buttonTitle, for: .normal)
        
        switch alertType {
        case .success:
            img.image = UIImage(named: "success")
            doneBtn.backgroundColor =  UIColor(named: "success")
        case .failure:
            img.image = UIImage(named: "failed")
            doneBtn.backgroundColor =  UIColor(named: "error")
        }
        
        UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }?.addSubview(self.parentView)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.parentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        })
        UIView.animate(withDuration: 0.2, delay: 0.1, options: [],
          animations: {
                self.alertView.alpha = 1
          },
          completion: nil
        )
    }
    
    
    
    @IBAction func onClickDone(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.parentView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            }, completion: { _ in
                self.parentView.removeFromSuperview()
            })
        })
    }
        
}
