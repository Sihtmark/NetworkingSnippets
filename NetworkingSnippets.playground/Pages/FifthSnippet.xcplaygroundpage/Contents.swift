import Foundation
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
var image = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 300))
image.backgroundColor = UIColor.yellow
image.contentMode = .scaleAspectFit
view.addSubview(image)

PlaygroundPage.current.liveView = view

var imageWidth = Int(view.bounds.width)
var imageHeight = Int(view.bounds.height)
let firstAPI = "https://picsum.photos/\(imageWidth)/\(imageHeight)"
let secondAPI = "https://picsum.photos/\(imageWidth)/\(imageHeight)"
let defaultQueue = DispatchQueue.global()
let backgroundQueue = DispatchQueue.global(qos: .background)

func fetchImage() {
    guard let firstApiURL = URL(string: firstAPI) else {
        fatalError("Some error")
    }
    guard let secondApiURL = URL(string: secondAPI) else {
        fatalError("Some error")
    }
    
    let session = URLSession(configuration: .default)
    
    let task1 = session.dataTask(with: firstApiURL) { (data, response, error) in
        
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async {
            image.image = UIImage(data: data)
            print("Show first 🏞️ data")
        }
        print("Did download 🌠 data")
    }
    
    let task2 = session.dataTask(with: secondApiURL) { (data, response, error) in
        guard let data = data, error == nil else { return }
        DispatchQueue.main.async {
            image.image = UIImage(data: data)
            print("Show second 🌁 data")
        }
        print("Did download 🌇 data")
    }
    
    defaultQueue.async {
        sleep(2)
        task1.resume()
    }
    
    backgroundQueue.async {
        task2.resume()
    }
}
fetchImage()

