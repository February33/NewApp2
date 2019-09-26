//
//  CustomTableViewCell.swift
//  NewsApp
//
//  Created by XP on 9/22/19.
//  Copyright © 2019 XP. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView! 
}

// MARK: - Cache images
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func load(url: URL) {
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    let imageToCache = image
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                    self.image = imageToCache
                }
            }
        }
    }
}
