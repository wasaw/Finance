//
//  ATMViewController.swift
//  Finance
//
//  Created by Александр Меренков on 16.10.2023.
//

import UIKit
import MapKit

private enum Constants {
    static let paddingButtom: CGFloat = -5
}

final class ATMViewController: UIViewController {

// MARK: - Properties
    
    private let output: ATMOutput
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        return map
    }()
    
// MARK: - Lifecycle
    
    init(output: ATMOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady(mapView.region)
        configureUI()
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(mapView)
        mapView.anchor(leading: view.leadingAnchor,
                       top: view.topAnchor,
                       trailing: view.trailingAnchor,
                       bottom: view.bottomAnchor,
                       paddingBottom: Constants.paddingButtom)
        view.backgroundColor = .white
    }
}

// MARK: - ATMInput

extension ATMViewController: ATMInput {
    func showUserLocation() {
        mapView.showsUserLocation = true
    }
    
    func setUserLocation(_ cooridate: MKCoordinateRegion, animated: Bool) {
        mapView.setRegion(cooridate, animated: animated)

    }
    
    func showAlert(message: String) {
        alert(with: "Внимание", message: message)
    }
    
    func showPlaces(_ places: [MKMapItem]) {
        for place in places {
            let annotation = MKPointAnnotation()
            annotation.coordinate = place.placemark.coordinate
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: false)
        }
    }
}

// MARK: - MKMapViewDelegate

extension ATMViewController: MKMapViewDelegate {
    
}
