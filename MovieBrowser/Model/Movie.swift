//
//  Movie.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 08/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import Foundation
import Alamofire

class Movie
{
    private enum NetworkURLS
    {
        
        func getRequestURL()
        {
            
        }
    }
    
    private let _movieID: Int!
    private let _movieName: String!
    private let _imageURLString: String!
    
    var movieID: Int
    {
        return _movieID
    }
    
    var movieName: String
    {
        return _movieName
    }
    
    var imageURLString: String
    {
        return _imageURLString
    }
    
    init(movieJSON: [String : Any]) throws
    {
        if let id = movieJSON["id"] as? Int, let title = movieJSON["title"] as? String, let imagePath = movieJSON["poster_path"] as? String
        {
            self._movieID = id
            self._movieName = title
            self._imageURLString = imagePath
        }
        else
        {
            throw NetworkError.jsonError("Invalid JSON")
        }
    }
    
    class func getMovies(completionHandler: @escaping (_ movieArray: [Movie]) -> ())
    {
        
    }
}
