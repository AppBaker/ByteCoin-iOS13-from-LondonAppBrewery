//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol BitcoinCostDelegate {
    func getBitcoinCost(bitcoinModel: BitcoinModel)
    func didFailWithError(with error: Error)
}

struct CoinManager {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var delegate: BitcoinCostDelegate?
    
    func getCoinPrice(for currency: String) {
        if let url = URL(string: baseURL + currency) {
            print(url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(with: error!)
                    print(error)
                    return
                }
                if let safeData = data {
                    if let bitcoin = self.parseJSON(data: safeData, currency: currency) {
                        print(#line, #function, bitcoin.cost)
                        self.delegate?.getBitcoinCost(bitcoinModel: bitcoin)
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(data: Data, currency: String) -> BitcoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(BitcoinData.self, from: data)
            return BitcoinModel(cost: decodeData.last, currency: currency)
        } catch {
            print(error)
            return nil
        }
    }
    
}
