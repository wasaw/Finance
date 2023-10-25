//
//  NewsOutput.swift
//  Finance
//
//  Created by Александр Меренков on 18.10.2023.
//

import Foundation

protocol NewsOutput: AnyObject {
    func viewIsReady()
    func updateData()
}
