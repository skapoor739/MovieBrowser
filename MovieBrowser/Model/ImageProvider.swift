//
//  ImageProvider.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 09/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import Alamofire

class ImageProvider
{
    static let sharedProvider = ImageProvider()
    
    private enum ImageURL: String
    {
        static let baseURL = "https://image.tmdb.org/t/p/"
        
        case widthLiteral = "w"
        
        static func getImageURL(width: Int, imagePath: String) -> URL?
        {
            let urlString = ImageURL.baseURL + widthLiteral.rawValue + "\(width)" + imagePath
            
            return try? urlString.asURL()
        }
    }
    
    private init() { }
    
    func getImage(width: Int, imagePath: String, completionHandler: @escaping (_ image: UIImage?) -> ())
    {
        var fetchedImage: UIImage? = nil
        
        if let data = CacheManager.sharedManager.getValue(forKey: imagePath) as? Data
        {
            if let image = UIImage(data: data)
            {
                completionHandler(image)
                return
            }
        }
        
        guard let url = ImageURL.getImageURL(width: width, imagePath: imagePath)
        else
        {
            completionHandler(fetchedImage)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData
            { [weak weakSelf = self] (responseResult) in
            
                guard let opSelf = weakSelf
                else
                {
                    return
                }
                
                defer { completionHandler(fetchedImage) }
                print(url)
                if let error = responseResult.error
                {
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = responseResult.data
                else
                {
                    return
                }
                
                if let image = UIImage(data: data)
                {
                    fetchedImage = image
                    CacheManager.sharedManager.setValue(value: image as AnyObject, forKey: imagePath)
                }
        }
    }
}
