//
//  AuthOutput.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import Foundation

protocol AuthOutput: AnyObject {
    func validation(segment: Int, credentials: AuthCredentials)
}
