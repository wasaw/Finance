//
//  CachePolice.swift
//  Finance
//
//  Created by Александр Меренков on 31.10.2023.
//

import Foundation

enum CachePolice {
    case cacheToDisk(CacheTime)
}

enum CacheTime: TimeInterval {
    case oneMinute = 60
}
