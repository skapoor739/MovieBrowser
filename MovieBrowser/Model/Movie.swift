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
    private let _plotInfo: String!
    private let _voteAverage: Double!
    private let _releaseDate: Date!
    
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
    
    var plotInfo: String
    {
        return _plotInfo
    }
    
    var voteAverage: Double
    {
        return _voteAverage
    }
    
    var releaseDateString: String
    {
        return Date.getFormattedDateString(fromDate: _releaseDate)
    }
    
    init(movieJSON: [String : Any]) throws
    {
        if let id = movieJSON["id"] as? Int, let title = movieJSON["title"] as? String, let imagePath = movieJSON["poster_path"] as? String, let plotInfo = movieJSON["overview"] as? String, let voteAverage = movieJSON["vote_average"] as? Double, let releaseDateString = movieJSON["release_date"] as? String, let releaseDate = Date.getDate(fromString: releaseDateString)
        {
            self._movieID = id
            self._movieName = title
            self._imageURLString = imagePath
            self._plotInfo = plotInfo
            self._voteAverage = voteAverage
            self._releaseDate = releaseDate
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
