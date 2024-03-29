//
//  Identifiable.swift
//  testProj
//
//  Created by Roman Mokh on 27.03.2024.
//

import Foundation

public protocol Identifiable: AnyObject {
    
    static var nibName: String { get }
    static var identifier: String { get }
}

public extension Identifiable {
    
    static var nibName: String {
        String(describing: Self.self)
    }
    
    static var identifier: String {
        String(describing: Self.self)
    }
}
