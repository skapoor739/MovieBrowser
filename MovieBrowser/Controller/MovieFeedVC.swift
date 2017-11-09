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
        
        NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor)
            ])
        
    }
    
    private func configureNavItem()
    {
        self.navigationItem.title = "Movie Browser"
    }
    
}

