//
//  CacheManager.swift
//  MovieBrowser
//
//  Created by Shivam Kapur on 09/11/17.
//  Copyright © 2017 ShivamKapur. All rights reserved.
//

import Foundation

class CacheManager
{
    static let sharedManager = CacheManager()
    
    private var _cache = NSCache<AnyObject, AnyObject>()
    
    private init() { }
    
    func setValue(value: AnyObject, forKey key: String)
    {
        _cache.setObject(value, forKey: key as AnyObject)
    }
    
    func removeValue(forKey key: String)
    {
        _cache.removeObject(forKey: key as AnyObject)
    }
    
    func getValue(forKey key: String) -> AnyObject?
    {
        return _cache.object(forKey: key as AnyObject)
    }
}
