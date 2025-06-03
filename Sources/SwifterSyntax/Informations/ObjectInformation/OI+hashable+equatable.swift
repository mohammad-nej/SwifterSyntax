//
//  OI+hashable+equatable.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/31/25.
//
import Foundation
extension ObjectInformation {
    public static func == (lhs: ObjectInformation, rhs: ObjectInformation) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
