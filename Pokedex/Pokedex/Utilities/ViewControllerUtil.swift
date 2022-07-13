//
//  ViewControllerUtil.swift
//  Pokedex
//
//  Created by axavierc on 23/06/2022.
//

import UIKit

class ViewControllerUtil: UIViewController {
    
    var isLoading:Bool = false      // var for loading state in load more
    var activityView: UIActivityIndicatorView?
    var uitext: UILabel?
    
    lazy var viewDark: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.8
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initObjs()
    }
    
    
    //MARK: - Functions
    
    private func initObjs(){
        uitext = UILabel()
        uitext?.textAlignment = .center
        uitext?.text = "g_loading".localized
        uitext?.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        uitext?.textColor = .white
        activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityView?.color = .white
        activityView?.center = self.view.center
        view.insertSubview(viewDark, at: 90)
        view.addSubview(activityView!)
        view.addSubview(uitext!)
    }
    
    func updateTextLoading(_ str: String) {
        DispatchQueue.main.async {
            self.uitext?.text = str
        }
    }

    func showActivityIndicator() {
        viewDark.frame = self.view.bounds
        uitext?.frame =  CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY + 60, width: self.view.bounds.width , height: self.view.bounds.height)
        viewDark.isHidden = false
        uitext?.isHidden = false
        activityView?.center = self.view.center
        isLoading = true
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            DispatchQueue.main.async {
                self.isLoading = false
                self.activityView?.stopAnimating()
                self.viewDark.isHidden = true
                self.uitext?.isHidden = true
            }
        }
    }
}



