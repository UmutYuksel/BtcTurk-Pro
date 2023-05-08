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
    
    private func handleRequest(url: URL, request: URLRequest, completion: @escaping (Result<T?, Error>) -> ()) {
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
    
    func send(method: HTTPMethod, url: URL, body: Data? = nil, completion: @escaping (Result<T?, Error>) -> ()) {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        handleRequest(url: url, request: request, completion: completion)
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}
