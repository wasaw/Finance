//
//  ATMPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 16.10.2023.
//

import Foundation
import MapKit

private enum Constants {
    static let regionRadius: CLLocationDistance = 200
}

final class ATMPresenter: NSObject {
    
// MARK: - Properties
    
    weak var input: ATMInput?
    private let locationManager = CLLocationManager()
    
// MARK: - Lifecycle
    
    override init() {
        super.init()
        locationManager.delegate = self
    }

// MARK: - Helpers
    
    private func checkAuthLockStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            input?.showAlert(message: """
                                        Для отображения информации, необходимо
                                        в настройках предоставить доступ к геолокации.
                                      """)
        case .authorizedAlways, .authorizedWhenInUse:
            input?.showUserLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
        @unknown default:
            break
        }
    }
}

// MARK: - ATMOutput

extension ATMPresenter: ATMOutput {
    func viewIsReady() {
        checkAuthLockStatus()
    }
}

// MARK: - CLLocationManagerDelegate

extension ATMPresenter: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthLockStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locationManager.location else { return }
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: Constants.regionRadius,
                                                  longitudinalMeters: Constants.regionRadius)
        input?.setUserLocation(coordinateRegion, animated: true)
    }
}
