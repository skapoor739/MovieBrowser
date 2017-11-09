//
//  Movie.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 08/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import Foundation

class Movie
{
    private let _movieName: String!
    private let _imageURLString: String!
    
    var movieName: String
    {
        return _movieName
    }
    
    var imageURLString: String
    {
        return _imageURLString
    }
    
    init(movieName: String, imageURLString: String)
    {
        self._movieName = movieName
        self._imageURLString = imageURLString
    }
    
    class func getMovies(completionHandler: @escaping (_ movieArray: [Movie]) -> ())
    {
        
    }
}
