//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 08/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import UIKit

class MovieFeedVC: UIViewController
{
    
    private lazy var collectionView: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .blue
        return cv
    }()
    
    override func loadView()
    {
        super.loadView()
        
        setupView()
        configureNavItem()
    }
    
    private func setupView()
    {
        view.backgroundColor = .white
        
        self.view.ext_addSubView(view: collectionView)
        
        
    }
    
    private func configureNavItem()
    {
        self.navigationItem.title = "Movie Browser"
    }
    
}

