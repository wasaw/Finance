//
//  ProfileOutput.swift
//  Finance
//
//  Created by Александр Меренков on 13.06.2023.
//

import Foundation

protocol ProfileOutput: AnyObject {
    func viewIsReady()
    func logOut()
    func saveImage(_ imageData: Any?)
}
