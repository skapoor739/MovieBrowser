//
//  MovieSearchVC.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 09/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import UIKit

class MovieSearchVC: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    private struct Identifiers
    {
        static let movieCellID = "movieCellID"
    }
    
    private var _currentPage: Int = 1
    
    private var _searchedMovies: [Movie] = []
    {
        didSet
        {
            collectionView.reloadData()
        }
    }
    
    private var searchText: String
    {
        return searchBar.text ?? ""
    }
    
    private var _searchOperation: Operation = Operation()
    
    private lazy var searchBar: UISearchBar =
    {
        let sb = UISearchBar()
        sb.delegate = self
        sb.barStyle = .default
        sb.placeholder = "Start typing a name..."
        sb.returnKeyType = .done
        return sb
    }()
    
    private lazy var collectionView: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func loadView()
    {
        super.loadView()
        
        setupView()
        registerCells()
        configureLayout()
    }
    
    private func setupView()
    {
        view.backgroundColor = .white
        
        view.ext_addSubView(view: searchBar)
        view.ext_addSubView(view: collectionView)
        
        NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
                searchBar.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return _searchedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.movieCellID, for: indexPath) as? MovieCVC
        else
        {
            return MovieCVC()
        }
        
        cell.movieObj = _searchedMovies[indexPath.item]
        
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
        let lastItem = _searchedMovies.count - 1
        
        if lastItem == indexPath.item
        {
            _currentPage += 1
            executeSearch(searchText: searchText)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.init(width: collectionView.bounds.width / 2, height: collectionView.bounds.height * 0.50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        _searchedMovies = []
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.count <= 2 { return }
        
        if _searchOperation.isExecuting { _searchOperation.cancel() }
        
        _searchedMovies = []
        _searchOperation = BlockOperation
        {   [weak weakSelf = self] in
            
            weakSelf?.executeSearch(searchText: searchText)
        }
        
        _searchOperation.start()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
    private func executeSearch(searchText: String)
    {
        NetworkEngine.sharedEngine.searchMovies(searchString: searchText, pageID: _currentPage)
        { [weak weakSelf = self] (movies, error) in
            
            guard let opSelf = weakSelf
                else
            {
                return
            }
            
            if let error = error
            {
                let message = NetworkError.getErrorMessage(type: error)
                opSelf.showAlert(title: "Error", message: message)
            }
            else
            {
                if !movies.isEmpty
                {
                    opSelf._searchedMovies.append(contentsOf: movies)
                    opSelf.collectionView.reloadData()
                }
                else
                {
                    opSelf.showAlert(title: "No more movies Were Found.", message: "")
                }
            }
        }
    }
}
