//
//  APIManager.swift
//  Proje-Test
//
//  Created by BTCYZ188 on 18.04.2023.
//

import Foundation
import Toast

//Mark for: APIManager to get post delete data's from API
struct APIManager<T: Decodable> {
    
    func get(url: URL, completion: @escaping (T?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    let configToast = ToastConfiguration(
                        direction: .bottom,
                        autoHide: true,
                        displayTime: 2,
                        animationTime: 0.2
                    )
                    let toast = Toast.text("\(error.localizedDescription)",config: configToast)
                    toast.show()
                }
                completion(nil)
            } else if let data = data {
                let result = try? JSONDecoder().decode(T.self, from: data)
                completion(result)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func post(url: URL, body: Data?, completion: @escaping (Result<T?, Error>) -> ()) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        let configToast = ToastConfiguration(
                            direction: .bottom,
                            autoHide: true,
                            displayTime: 2,
                            animationTime: 0.2
                        )
                        let toast = Toast.text("\(error.localizedDescription)",config: configToast)
                        toast.show()
                    }
                    completion(.failure(error))
                } else if let data = data {
                    let result = try? JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } else {
                    completion(.success(nil))
                }
            }.resume()
        }
        
        func delete(url: URL, completion: @escaping (Result<Void, Error>) -> ()) {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        let configToast = ToastConfiguration(
                            direction: .bottom,
                            autoHide: true,
                            displayTime: 2,
                            animationTime: 0.2
                        )
                        let toast = Toast.text("\(error.localizedDescription)",config: configToast)
                        toast.show()
                    }
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }.resume()
        }
}
