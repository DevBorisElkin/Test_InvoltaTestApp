import Foundation
import UIKit

class WebImageView: UIImageView {
    
    private var currentUrlString: String?
    
    func set(imageURL: String?, cacheAndRetrieveImage: Bool = true){
        
        currentUrlString = imageURL
        
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            self.image = nil
            print("couldn't convert url string to URL \(imageURL)")
            return }
        
        if cacheAndRetrieveImage, let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)){
            self.image = UIImage(data: cachedResponse.data)
            print("load image from cache \(imageURL)")
            return
        }
        
        print("load image from internet: \(imageURL)")
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            DispatchQueue.main.async {
                if let data = data, let response = response, error == nil {
                    self?.handleLoadedImage(data: data, response: response, cacheAndRetrieveImage: cacheAndRetrieveImage )
                }else if let error = error {
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse, cacheAndRetrieveImage: Bool = true){
        guard let responseUrl = response.url else{ print("Unexpected error");return }
        print("handleLoadedImage")
        if(cacheAndRetrieveImage){
            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseUrl))
        }
        
        if responseUrl.absoluteString == currentUrlString {
            self.image = UIImage(data: data)
        }
    }
    
    // _____
    
    func setImage(imageUrlString: String) {
        DispatchQueue.global(qos: .background).async {
            var image = WebImageView.loadImageForImageView(urlString: imageUrlString)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
        
    }
    
    static func loadImageForImageView(urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else {print("Wrong URL to load image"); return nil }
        guard let imageData = try? Data(contentsOf: url) else {print("Something is wrong with loaded image, returning"); return nil }
        return UIImage(data: imageData)
    }
}
