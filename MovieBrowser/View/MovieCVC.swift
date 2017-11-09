//
//  MovieCVC.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 09/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import UIKit

class MovieCVC: UICollectionViewCell
{
    private var moviePosterIV: UIImageView =
    {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private var movieNameLabel: UILabel =
    {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    var imageOperation: Operation!
    
    var movieObj: Movie? = nil
    {
        didSet
        {
            guard let movie = movieObj
            else
            {
                resetUI()
                return
            }
            
            movieNameLabel.text = movie.movieName
            
            imageOperation = BlockOperation
            {   [weak weakSelf = self] in
                guard let opSelf = weakSelf
                else
                {
                    return
                }
                
                opSelf.getImage(path: movie.imageURLString)
            }
            
            imageOperation.start()
            
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func setupView()
    {
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        contentView.ext_addSubView(view: moviePosterIV)
        
        contentView.ext_addSubView(view: movieNameLabel)
        
        NSLayoutConstraint.activate([
            moviePosterIV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            moviePosterIV.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            moviePosterIV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            moviePosterIV.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4),
            ])
        
        NSLayoutConstraint.activate([
                movieNameLabel.bottomAnchor.constraint(equalTo: moviePosterIV.bottomAnchor),
                movieNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                movieNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            ])
    }
    
    func getImage(path: String)
    {
        ImageProvider.sharedProvider.getImage(width: 500, imagePath: path)
        { [weak weakSelf = self] (image) in
            
            guard let opSelf = weakSelf
            else
            {
                return
            }
            
            if let image = image
            {
                opSelf.moviePosterIV.image = image
            }
        }
    }

    private func resetUI()
    {
        movieNameLabel.text = ""
        moviePosterIV.image = nil
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        if imageOperation.isExecuting
        {
            imageOperation.cancel()
        }
        
        resetUI()
    }
}
