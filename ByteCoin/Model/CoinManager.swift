//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinCurrent( _ current: CoinModel )
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "81F58F6A-B39E-48E6-8DBE-3C948B88A4DE"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let trueUrl = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
        performRequest(with: trueUrl)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData){
                        self.delegate?.didUpdateCoinCurrent(coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON( _ coinData: Data ) -> CoinModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let time = decodedData.time
            let asset_id_base = decodedData.asset_id_base
            let asset_id_quote = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            return CoinModel(time: time, assetIdBase: asset_id_base, assetIdQuote: asset_id_quote, rate: rate)
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
