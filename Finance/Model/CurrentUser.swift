//
//  CurrentUser.swift
//  Finance
//
//  Created by Александр Меренков on 20.09.2022.
//

import Foundation

protocol Subscriber: AnyObject {
    func update(subject: User?)
}

class CurrentUser {
    private lazy var subscribers: [WeakSubscriber] = []
    private var subject: User? = nil
    
    func setValue(user: User?) {
        self.subject = user
        self.notify()
    }
    
    func deleteValue() {
        self.subject = nil
        self.notify()
    }
    
    func subscribe(_ subscriber: Subscriber) {
        subscribers.append(WeakSubscriber(value: subscriber))
    }
    
    func unsubscribe(_ subscriber: Subscriber) {
        subscribers.removeAll(where: {$0.value === subscriber})
    }
    
    private func notify() {
        subscribers.forEach{$0.value?.update(subject: self.subject)}
    }
}

struct WeakSubscriber {
    weak var value: Subscriber?
}
