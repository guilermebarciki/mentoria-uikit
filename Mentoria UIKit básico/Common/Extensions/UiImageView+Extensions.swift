
import Foundation
import UIKit

extension UIImageView {
    
    private static let cachedImage = NSCache<NSString, UIImage>()
    
    func loadImage(urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        let key = urlString as NSString
        
        if let image = UIImageView.cachedImage.object(forKey: key) {
            self.image = image
            return
        }
        
        self.image = placeholder
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            if let data, let image = UIImage(data: data) {
                UIImageView.cachedImage.setObject(image, forKey: key)
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }
}



import ObjectiveC.runtime

private var taskKey: UInt8 = 0
extension UIImageView {
    
    private var task: URLSessionDataTask? {
        get { objc_getAssociatedObject(self, &taskKey) as? URLSessionDataTask }
        set { objc_setAssociatedObject(self, &taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func loadImageWithCanceling(urlString: String, placeholder: UIImage? = nil) {
        task?.cancel()
        guard let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        let key = urlString as NSString
        
        if let image = UIImageView.cachedImage.object(forKey: key) {
            self.image = image
            return
        }
        
        self.image = placeholder
        
        task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            if let data, let image = UIImage(data: data) {
                UIImageView.cachedImage.setObject(image, forKey: key)
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
        task?.resume()
    }
}

