//
//  OverlayView .swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 09/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import UIKit

class OverlayView: UIView
{
    private var activityIndicator: UIActivityIndicatorView =
    {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        return ai
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) could not be implemented.")
    }
    
    private func setupView()
    {
        backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        
        ext_addSubView(view: activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        self.alpha = 0
    }
    
    func start()
    {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.4) { [weak weakSelf = self] in
            weakSelf!.alpha = 1
        }
    }
    
    func hide()
    {
        UIView.animate(withDuration: 0.4) { [weak weakSelf = self] in
            weakSelf!.alpha = 0
        }
    }
}
