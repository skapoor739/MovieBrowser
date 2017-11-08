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
