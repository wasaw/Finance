//
//  ProgressPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 13.11.2023.
//

import Foundation

enum ProgressSection: Hashable, CaseIterable {
    case section
}

struct ProgressItem: Hashable {
    let id = UUID()
    let title: String
    let isShow: Bool
}

final class ProgressPresenter {
    
// MARK: - Properties
    
    weak var input: ProgressInput?
    private let output: ProfilePresenterOutput
    
// MARK: - Lifecycle
    
    init(output: ProfilePresenterOutput) {
        self.output = output
    }
}

// ProgressOutput

extension ProgressPresenter: ProgressOutput {
    func viewIsReady() {
        input?.setProgressItem([ProgressItem(title: "Отображать прогресс", isShow: true)])
    }
}
