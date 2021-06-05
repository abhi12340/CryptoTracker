//
//  APICaller.swift
//  CryptoTracker
//
//  Created by Abhishek Kumar on 05/06/21.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    public var icon = [Icon]()
    
    private var whenReadyBlock: ((Result<[Crypto] , Error>) -> Void)?
    
    private struct Constants {
        static let apiKey = "7467DAC0-7A25-4637-AFE1-DE70B517C5C0"
//        static let assestEndpoint = "https://rest-sandbox.coinapi.io/v1/assets"
        static let assestEndpoint = "https://rest.coinapi.io/v1/assets"
        
        static let assestIconendpoint = "https://rest.coinapi.io/v1/assets/icons/32"
    }
    
    private init() {}
    
    func getCryptoData(completionHandler: @escaping (Result<[Crypto] , Error>) -> Void) {
        
        guard !icon.isEmpty else {
            whenReadyBlock = completionHandler
            return
        }
        
        guard let url = URL(string: Constants.assestEndpoint + "?apikey=" + Constants.apiKey) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let cyrptos = try JSONDecoder().decode([Crypto].self, from: data)
                
                completionHandler(.success(cyrptos.sorted(by: { (first, second) -> Bool in
                    first.priceUsd ?? 0 > second.priceUsd ?? 0
                })))
            } catch {
                completionHandler(.failure(error))
            }
            
        }
        
        task.resume()
    }
    
    
    public func getAllIcons() {
        guard let url = URL(string:  Constants.assestIconendpoint + "?apikey=" + Constants.apiKey) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                self?.icon = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.whenReadyBlock {
                    self?.getCryptoData(completionHandler: completion)
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
}
