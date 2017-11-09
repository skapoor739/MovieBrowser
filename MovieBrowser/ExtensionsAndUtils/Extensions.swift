//
//  Extensions.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 08/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import UIKit

extension UIView
{
    func ext_addSubView(view: UIView)
    {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
    }
}

extension UIViewController
{
    func showAlert(title: String, message: String)
    {
        let alertCon = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertCon.addAction(action)
        self.present(alertCon, animated: true, completion: nil)
    }
    
}
