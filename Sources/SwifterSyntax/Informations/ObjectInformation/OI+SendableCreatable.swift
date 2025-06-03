//
//  OI+SendableCreatable.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/26/25.
//

public extension ObjectInformation {
    
    var sendable: SendableObjectInformation {
        .init(from: self)
    }
    
    
}
