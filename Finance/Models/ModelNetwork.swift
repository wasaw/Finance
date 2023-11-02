//
//  ModelDecodable.swift
//  Finance
//
//  Created by Александр Меренков on 31.01.2023.
//

// MARK: - Currency

struct ExchangeRateDataModel: Codable {
    let result: String
    let conversionRates: ExchangeItem
}

extension ExchangeRateDataModel {
    struct ExchangeItem: Codable, Sequence {
        let BGN: Double
        let CZK: Double
        let EUR: Double
        let GBP: Double
        let KZT: Double
        let NZD: Double
        let RUB: Double
        let USD: Double
        
        func makeIterator() -> CurrencyItemIterator {
            return CurrencyItemIterator(currency: self)
        }
    }
    
    struct CurrencyItemIterator: IteratorProtocol {
        typealias Element = (String, Double)
        private var index = 0
        private var amountArray = [Double]()
        private var nameArray = [String]()

        init(currency: ExchangeItem) {
            self.amountArray.append(currency.BGN)
            self.amountArray.append(currency.CZK)
            self.amountArray.append(currency.EUR)
            self.amountArray.append(currency.GBP)
            self.amountArray.append(currency.KZT)
            self.amountArray.append(currency.NZD)
            self.amountArray.append(currency.RUB)
            self.amountArray.append(currency.USD)
            
            self.nameArray.append("BGN")
            self.nameArray.append("CZK")
            self.nameArray.append("EUR")
            self.nameArray.append("GBP")
            self.nameArray.append("KZT")
            self.nameArray.append("NZD")
            self.nameArray.append("RUB")
            self.nameArray.append("USD")
        }

        mutating func next() -> CurrencyItemIterator.Element? {
            if index < amountArray.count {
                let answer = (nameArray[index], amountArray[index])
                index += 1
                return answer
            }
            return nil
        }
    }
}

// MARK: - Stock

struct StockRateDataModel: Codable {
    let queryCount: Int
    let results: [StockItem]
}

extension StockRateDataModel {
    struct StockItem: Codable {
        let symbol: String
        let value: Double
        
        enum CodingKeys: String, CodingKey {
            case symbol = "T"
            case value = "c"
        }
    }
}

// MARK: - News

struct NewsDataModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticles]
}

extension NewsDataModel {
    struct NewsArticles: Codable {
        let title: String
        let description: String?
        let url: String
        let urlToImage: String?
        let publishedAt: String
    }
}
