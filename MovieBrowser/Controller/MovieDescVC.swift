//
//  MovieDescVC.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 09/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import UIKit

class MovieDescVC: UIViewController
{
    private var _movie: Movie!
    
    private var backgroundImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var moviePosterImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //        imageView.backgroundColor = .black
        return imageView
    }()
    
    private var movieNameLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Light", size: 18)
        label.textAlignment = .center
        return label
    }()
    
    private var moviePlotLabel: UILabel =
    {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Helvetica", size: 15)
        label.textAlignment = .center
        return label
    }()
    
    private var ratingLabel: UILabel =
    {
        let label = UILabel()
        label.text = "7.6"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private var releaseDateLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 14)
        label.textAlignment = .center
        return label
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented.")
    }
    
    convenience init(movie: Movie)
    {
        self.init(nibName: nil, bundle: nil)
        self._movie = movie
    }
    
    override func loadView()
    {
        super.loadView()
        
        setupView()
        setNavBar()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupUI(movie: _movie)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
    }
    
    func setupView()
    {
        view.backgroundColor = UIColor.white
        
        view.ext_addSubView(view: backgroundImageView)
        view.ext_addSubView(view: movieNameLabel)
        view.ext_addSubView(view: moviePosterImageView)
        view.ext_addSubView(view: releaseDateLabel)
        view.ext_addSubView(view: ratingLabel)
        view.ext_addSubView(view: moviePlotLabel)
        
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            movieNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            movieNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            movieNameLabel.heightAnchor.constraint(equalToConstant: 34)
            ])
        
        NSLayoutConstraint.activate([
            moviePosterImageView.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 12),
            moviePosterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 150),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 150)
            
            ])
        
        
        NSLayoutConstraint.activate([
            releaseDateLabel.topAnchor.constraint(equalTo: moviePosterImageView.bottomAnchor, constant: 12),
            releaseDateLabel.leftAnchor.constraint(equalTo: movieNameLabel.leftAnchor),
            releaseDateLabel.rightAnchor.constraint(equalTo: movieNameLabel.rightAnchor),
            releaseDateLabel.heightAnchor.constraint(equalToConstant: 24)
            ])
        
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            ratingLabel.leftAnchor.constraint(equalTo: movieNameLabel.leftAnchor),
            ratingLabel.rightAnchor.constraint(equalTo: movieNameLabel.rightAnchor),
            ratingLabel.heightAnchor.constraint(equalToConstant: 24)
            ])
        
        NSLayoutConstraint.activate([
            moviePlotLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 12),
            moviePlotLabel.leftAnchor.constraint(equalTo: movieNameLabel.leftAnchor),
            moviePlotLabel.rightAnchor.constraint(equalTo: movieNameLabel.rightAnchor),
            moviePlotLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
            ])
        
    }
    
    private func setNavBar()
    {
        self.navigationItem.title = "MOVIE INFORMATION"
    }
    
    func blurBackgroundImage(_ image: UIImage)
    {
        // Make a frame the size of the current view
        let frame = CGRect(x: 0, y: 0, width: self.backgroundImageView.frame.width, height: self.backgroundImageView.frame.height)
        // Make an image view using that frame
        let imageView = UIImageView(frame: frame)
        
        // Push the received image into the new image view and scale it
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        // Create a blur effect view and blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        
        // set up a layer with 30% alpha to dull the blur colors
        let transparentWhiteView = UIView(frame: frame)
        transparentWhiteView.backgroundColor = UIColor(white: 1.0, alpha: 0.30)
        
        // Add views to our view with an Array
        var viewsArray = [imageView, blurEffectView, transparentWhiteView]
        
        // use a half closed range
        for index in 0..<viewsArray.count {
            // remove any old background views with tags
            if let oldView = view.viewWithTag(index + 1) {
                oldView.removeFromSuperview()
            }
            
            // insert the view into
            let viewToInsert = viewsArray[index]
            viewToInsert.alpha = 0
            
            self.view.insertSubview(viewToInsert, at: index + 1)
            
            UIView.animate(withDuration: 0.5, animations: {
                viewToInsert.alpha = 1
            })
            
            // add the tag in order to remove for the next time
            viewToInsert.tag = index + 1
        }
    }
    
    private func setupUI(movie: Movie)
    {
        movieNameLabel.text = movie.movieName
        moviePlotLabel.text = movie.plotInfo
        releaseDateLabel.text = "Released on: \(movie.releaseDateString)"
        ratingLabel.text = "Rating: \(movie.voteAverage)"
        addImage(path: movie.imageURLString)
    }
    
    private func addImage(path: String)
    {
        ImageProvider.sharedProvider.getImage(width: 500, imagePath: path)
        { [weak weakSelf = self] (image) in
            
            guard let opSelf = weakSelf
                else
            {
                return
            }
            
            guard let img = image
                else
            {
                return
            }
            
            UIView.transition(with: opSelf.moviePosterImageView, duration: 0.75, options: .transitionCrossDissolve, animations: {
                opSelf.moviePosterImageView.image = image
            }, completion: { (success) in
                opSelf.blurBackgroundImage(img)
            })
        }
        

    }

}
