//
//  ATMInput.swift
//  Finance
//
//  Created by Александр Меренков on 16.10.2023.
//

import Foundation
import MapKit

protocol ATMInput: AnyObject {
    func showUserLocation()
    func setUserLocation(_ cooridate: MKCoordinateRegion, animated: Bool)
    func showAlert(message: String)
}
