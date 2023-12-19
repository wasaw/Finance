//
//  HomePresenterOutput.swift
//  Finance
//
//  Created by Александр Меренков on 10.06.2023.
//

import Foundation

protocol HomeOutput: AnyObject {
    func viewIsReady()
    func showService(at: Int)
}
