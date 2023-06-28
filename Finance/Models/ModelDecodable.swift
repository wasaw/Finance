//
//  ModelDecodable.swift
//  Finance
//
//  Created by Александр Меренков on 31.01.2023.
//

// MARK: - Currency

struct ConversionRates: Decodable {
    let result: String
    let conversion_rates: CurrencyJson
}

struct CurrencyJson: Decodable, Sequence {
    let BGN: Double
    let CZK: Double
    let EUR: Double
    let GBP: Double
    let KZT: Double
    let NZD: Double
    let RUB: Double
    let USD: Double
 
    func makeIterator() -> CurrencyJsonIterator {
        return CurrencyJsonIterator(currency: self)
    }
}

struct CurrencyJsonIterator: IteratorProtocol {
    typealias Element = (String, Double)
    private var index = 0
    private var amountArray = [Double]()
    private var nameArray = [String]()

    init(currency: CurrencyJson) {
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

    mutating func next() -> CurrencyJsonIterator.Element? {
        if index < amountArray.count {
            let answer = (nameArray[index], amountArray[index])
            index += 1
            return answer
        }
        return nil
    }
}

// MARK: - Stock

struct StockRate: Decodable {
    let queryCount: Int
    let results: [StockItem]
}

struct StockItem: Decodable {
    let symbol: String
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case symbol = "T"
        case value = "c"
    }
}
