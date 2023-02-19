//
//  Model+Service.swift
//  VK2023
//
//  Created by Матвей Матюшко on 19.02.2023.
//

import Foundation
import UIKit

struct AboutServicesModel: Codable {
    var name: String
    var description: String
    var icon_url: String
    var service_url: String
}

struct Service {
    func getDataURL(completion: @escaping ([[String : String]]?, Error?) -> Void){
        let validUrl = "https://mobile-olympiad-trajectory.hb.bizmrg.com/semi-final-data.json"
        let url = URL(string: validUrl)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let someDictionaryFromJSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let arrayOfServices = someDictionaryFromJSON?["items"] as? [[String: String]]
            completion(arrayOfServices, error)
        }
        task.resume()
    }
    
    func loadImage(urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let image = UIImage(data: data, scale:1)
            completion(image, error)
        }
        task.resume()
    }
}
