//
//  NewsAPI.swift
//  NewsApp
//
//  Created by XP on 9/22/19.
//  Copyright © 2019 XP. All rights reserved.
//

import Foundation

class NewsAPI {
    // MARK: - Variables
    var source: Source
    var title: String
    var author: String
    var description: String
    var urlToImage: String
    var url: String
    var publishedAt: String

    // MARK: - Init variables
    init(dictionary : [String : Any]) {
        source = Source(dictionary: dictionary["source"] as! [String : Any])
        title = dictionary["title"] as? String ?? ""
        author = dictionary["author"] as? String ?? ""
        description = dictionary["description"] as? String ?? ""
        urlToImage = dictionary["urlToImage"] as? String ?? ""
        url = dictionary["url"] as? String ?? ""
        publishedAt = dictionary["publishedAt"] as? String ?? ""
    }

}

class Source {
    // MARK: - Variables
    var name: String
    
    // MARK: - Init variables
    init(dictionary : [String : Any]) {
        name = dictionary["name"] as? String ?? ""
    }
}
