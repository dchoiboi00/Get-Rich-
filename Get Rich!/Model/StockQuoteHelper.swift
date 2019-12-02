//
//  StockQuoteFetcher.swift
//  Stox
//
//  Created by CSC214 Instructor on 11/11/19.
//  Copyright © 2019 University of Rochester. All rights reserved.
//

import Foundation

let kBaseUrl = "https://financialmodelingprep.com/api/v3/company/profile/"

enum StockQuoteHelperResult: Error {
    case Success(Stock)
    case Failure(Error)
}

class StockQuoteHelper {

    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    private func getStock(from data: Data) -> StockQuoteHelperResult {
        do {
            let decoder = JSONDecoder()
            let stock = try decoder.decode(Stock.self, from: data)
            return .Success(stock)
        } catch let error {
            return .Failure(error)
        }
    }
    
    func fetchStock(for symbol: String, completion: @escaping (StockQuoteHelperResult) -> Void) {
        
        let urlString = kBaseUrl + symbol
        if let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request) { (data, response, error) -> Void in
                guard let stockData = data else {
                    if let err = error {
                        completion(.Failure(err))
                    }
                    return
                }
                completion(self.getStock(from: stockData))
            }
            task.resume()
        } else {
            completion(.Failure(URLError.BadURL))
        }
    }

}
