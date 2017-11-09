//
//  NetworkEngine.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 09/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import Alamofire

enum NetworkError: Error
{
    case invalidURL(String)
    case invalidParameters(String)
    case requestFailed(String)
    case noData(String)
    case jsonError(String)
    
    static func getErrorMessage(type: NetworkError) -> String
    {
        let message: String
        
        switch type
        {
        case invalidURL(let error):
            message = error
            break
        case invalidParameters(let error):
            message = error
            break
        case requestFailed(let error):
            message = error
            break
        case noData(let error):
            message = error
            break
        case jsonError(let error):
            message = error
            break
        }
        
        return message
    }
}

final class NetworkEngine
{
    static let sharedEngine = NetworkEngine()
    
    private enum URLManager: String
    {
        static let baseURL = "https://api.themoviedb.org"
        static let apiKey = "?api_key=9d9bbdea25314385e94cb00f52a342e6"
        
        
        case movieReq = "/3/discover/movie"
        case movieSearch = "/3/search/movie"
        case page = "&page="
        case queryString = "&query="
        
        static func getMovieReqURL(withPage page: Int = 1) -> URL?
        {
            let urlString = URLManager.baseURL + URLManager.movieReq.rawValue + URLManager.apiKey + URLManager.page.rawValue + "\(page)"
            
            return try? urlString.asURL()
        }
        
        static func getMovieSearchURL(searchString: String) -> URL?
        {
            let urlString = URLManager.baseURL + URLManager.movieSearch.rawValue + URLManager.apiKey + URLManager.queryString.rawValue + searchString.addingPercentEncoding( withAllowedCharacters: .urlHostAllowed)!

            
            return try? urlString.asURL()
        }
    }
    
    private let _accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5ZDliYmRlYTI1MzE0Mzg1ZTk0Y2IwMGY1MmEzNDJlNiIsInN1YiI6IjVhMDNlODJlOTI1MTQxMmRmODAwODEzMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Rmgnehh742VmfAz1kXF24KLnfVJ28VbmlWyxnyvGDdo"
    
    private init() { }
    
    func getMovies(pageID: Int, completionHandler: @escaping (_ movieArray: [Movie], _ error: NetworkError?) -> ())
    {
        var networkErr: NetworkError? = nil
        var movieArr: [Movie] = [Movie]()
        
        guard let url = URLManager.getMovieReqURL(withPage: pageID)
        else
        {
            completionHandler(movieArr, NetworkError.invalidURL("Invalid URL"))
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON
            { [weak weakSelf = self] (responseResult) in
            
                defer { completionHandler(movieArr, networkErr) }
                
                guard let opSelf = weakSelf
                else
                {
                    networkErr = NetworkError.requestFailed("Unknown Error occured.")
                    return
                }
                
                if let error = responseResult.error
                {
                    networkErr = NetworkError.requestFailed(error.localizedDescription)
                    return
                }
                
                guard let data = responseResult.data
                else
                {
                    networkErr = NetworkError.noData("No Data Received.")
                    return
                }
                
                guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                else
                {
                    networkErr = NetworkError.jsonError("Error parsing json.")
                    return
                }
                
                if let movieData = jsonData as? [String : Any], let movieResults = movieData["results"] as? [[String : Any]]
                {
                    for movieJSON in movieResults
                    {
                        print(movieJSON)
                        if let movie = try? Movie(movieJSON: movieJSON)
                        {
                            movieArr.append(movie)
                        }
                    }
                }
                else
                {
                    networkErr = NetworkError.jsonError("Invalid JSON.")
                }
        }
    }
    
    func searchMovies(searchString: String, completionHandler: @escaping (_ movies: [Movie], _ error: NetworkError?) -> ())
    {
        var networkErr: NetworkError? = nil
        var movieArr: [Movie] = [Movie]()
        
        guard let url = URLManager.getMovieSearchURL(searchString: searchString)
            else
        {
            completionHandler(movieArr, NetworkError.invalidURL("Invalid URL"))
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON
            { [weak weakSelf = self] (responseResult) in
                
                defer { completionHandler(movieArr, networkErr) }
                
                guard let opSelf = weakSelf
                    else
                {
                    networkErr = NetworkError.requestFailed("Unknown Error occured.")
                    return
                }
                
                if let error = responseResult.error
                {
                    networkErr = NetworkError.requestFailed(error.localizedDescription)
                    return
                }
                
                guard let data = responseResult.data
                    else
                {
                    networkErr = NetworkError.noData("No Data Received.")
                    return
                }
                
                guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    else
                {
                    networkErr = NetworkError.jsonError("Error parsing json.")
                    return
                }
                
                if let movieData = jsonData as? [String : Any], let movieResults = movieData["results"] as? [[String : Any]]
                {
                    for movieJSON in movieResults
                    {
                        print(movieJSON)
                        if let movie = try? Movie(movieJSON: movieJSON)
                        {
                            movieArr.append(movie)
                        }
                    }
                }
                else
                {
                    networkErr = NetworkError.jsonError("Invalid JSON.")
                }
        }
    }
    
}
