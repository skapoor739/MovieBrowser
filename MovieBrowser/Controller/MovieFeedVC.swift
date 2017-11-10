//
//  ViewController.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 08/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import UIKit

class MovieFeedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MovieFilterDelegate
{
    private var _movies: [Movie] = []
    
    private var _selectedSortPredicate: MenuOption? = nil
    
    private var _currentPage: Int = 1
    
    private struct Identifiers
    {
        static let movieCellID = "movieCellID"
    }
    
    private lazy var searchBarButton: UIBarButtonItem =
    {
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        return button
    }()
    
    private lazy var filterBarButton: UIBarButtonItem =
    {
        let button = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped(_:)))
        return button
    }()
    
    private lazy var collectionView: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private var overlayView: OverlayView =
    {
        let ov = OverlayView()
        return ov
    }()
    
    override func loadView()
    {
        super.loadView()
        setupView()
        configureNavItem()
        registerCells()
        configureLayout()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadMovies()
    }
    
    private func setupView()
    {
        view.backgroundColor = .white
        
        self.view.ext_addSubView(view: collectionView)
        self.view.ext_addSubView(view: overlayView)
        
        NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor)
            ])
        
        NSLayoutConstraint.activate([
                overlayView.topAnchor.constraint(equalTo: view.topAnchor),
                overlayView.leftAnchor.constraint(equalTo: view.leftAnchor),
                overlayView.rightAnchor.constraint(equalTo: view.rightAnchor),
                overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
    }
    
    private func configureNavItem()
    {
        self.navigationItem.title = "Movie Browser"
        
        self.navigationItem.rightBarButtonItems = [filterBarButton, searchBarButton]
    }
    
    private func registerCells()
    {
        collectionView.register(MovieCVC.self, forCellWithReuseIdentifier: Identifiers.movieCellID)
    }
    
    private func configureLayout()
    {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else
        {
            return
        }
        
        layout.scrollDirection = .vertical
    }
    
    private func loadMovies(pageID: Int = 1, sortPredicate: String = NetworkEngine.SortKeys.SORT_BY_POPULAR)
    {
        overlayView.start()
        NetworkEngine.sharedEngine.getMovies(pageID: pageID, sortPredicate: sortPredicate)
        { [weak weakSelf = self] (movies, error) in
            
            guard let opSelf = weakSelf
            else
            {
                return
            }
            
            opSelf.overlayView.hide()
            if let error = error
            {
                let message = NetworkError.getErrorMessage(type: error)
                opSelf.showAlert(title: "Error", message: message)
            }
            else
            {
                if !movies.isEmpty
                {
                    opSelf._movies.append(contentsOf: movies)
                    opSelf.collectionView.reloadData()
                }
                else
                {
                    opSelf.showAlert(title: "No Movies Were Found.", message: "")
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return _movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.movieCellID, for: indexPath) as? MovieCVC
        else
        {
            return MovieCVC()
        }
        
        cell.movieObj = _movies[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCVC, let movie = cell.movieObj
        else
        {
            return
        }
        
        let movieDescVC = MovieDescVC(movie: movie)
        self.navigationController?.pushViewController(movieDescVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        let lastItem = _movies.count - 1
        
        if lastItem == indexPath.item
        {
            _currentPage += 1
            let predicate = _selectedSortPredicate != nil ? _selectedSortPredicate!.apiReqString : NetworkEngine.SortKeys.SORT_BY_POPULAR
            loadMovies(pageID: _currentPage, sortPredicate: predicate)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.init(width: collectionView.bounds.width / 2, height: collectionView.bounds.height * 0.45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    @objc
    private func searchTapped(_ sender: UIBarButtonItem)
    {
        let searchVC = MovieSearchVC()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
 
    @objc
    private func filterTapped(_ sender: UIBarButtonItem)
    {
        let filterVC = MovieFilterVC()
        filterVC.delegate = self
        filterVC.sortPredicate = _selectedSortPredicate
        self.navigationController?.pushViewController(filterVC, animated: true)
    }
    
    func didSelectPredicate(viewCon: MovieFilterVC, type: MenuOption)
    {
        _selectedSortPredicate = type
        loadMovies(sortPredicate: type.apiReqString)
    }
}

