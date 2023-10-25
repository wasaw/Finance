//
//  ImageCache.swift
//  Finance
//
//  Created by Александр Меренков on 24.10.2023.
//

import UIKit

final class ImageCache {
    static let publicCache = ImageCache()
    
// MARK: - Properties
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    
// MARK: - Helpers
    
    private func image(_ url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    func load(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = image(url as NSURL) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data,
                  let image = UIImage(data: data),
                    error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.cachedImages.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
