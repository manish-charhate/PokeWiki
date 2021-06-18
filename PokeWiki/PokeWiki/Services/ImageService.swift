//
//  ImageService.swift
//  PokeWiki
//
//  Created by Manish Charhate on 17/06/21.
//

import UIKit
/**
 Provides services related to image.
 */
final class ImageService {

    /**
     Fetches image from the URL and returns it to the caller.

     - parameter url: URL of an image to fetch.
     - parameter completionHandler: A block to be called on completion of image fetch.
     */
    static func image(for url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                completionHandler(image)
            } catch {
                print("Unable fetch image from url - \(url) due to error \(error)")
            }
        }
    }

}
