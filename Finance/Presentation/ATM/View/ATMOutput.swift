//
//  ATMOutput.swift
//  Finance
//
//  Created by Александр Меренков on 16.10.2023.
//

import Foundation
import MapKit

protocol ATMOutput: AnyObject {
    func viewIsReady(_ region: MKCoordinateRegion)
}
