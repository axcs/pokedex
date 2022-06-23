//
//  ViewControllerUtil.swift
//  Pokedex
//
//  Created by axavierc on 23/06/2022.
//

import UIKit

class ViewControllerUtil: UIViewController {
    
    var activityView: UIActivityIndicatorView?
    var uitext: UILabel?
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initObjs()
    }
    
    
    //MARK: - Functions
    
    private func initObjs(){
        uitext = UILabel()
        uitext?.textAlignment = .center
        uitext?.text = "Loading..."
        uitext?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        uitext?.textColor = .white
        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityView?.color = .white
        activityView?.center = self.view.center
        view.insertSubview(blurEffectView, at: 90)
        view.addSubview(activityView!)
        view.addSubview(uitext!)
    }
    
    func updateTextLoading(_ str: String) {
        DispatchQueue.main.async {
            self.uitext?.text = str
        }
    }

    func showActivityIndicator() {
        blurEffectView.frame = self.view.bounds
        uitext?.frame =  CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY + 60, width: self.view.bounds.width , height: self.view.bounds.height)
        blurEffectView.isHidden = false
        uitext?.isHidden = false
        activityView?.center = self.view.center
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
            blurEffectView.isHidden = true
            uitext?.isHidden = true
        }
    }
    
    func showError(msg: String?) {
           let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: msg ?? NSLocalizedString("DefaultErrorKey", comment: ""), preferredStyle: .alert)
           
           alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
           self.present(alert, animated: true)
       }
}



