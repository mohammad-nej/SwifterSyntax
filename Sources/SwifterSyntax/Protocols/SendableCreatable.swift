//
//  SendableCreatable.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/26/25.
//

public protocol SendableCreatable {
    associatedtype Value : Sendable
    var sendable : Value { get }
}
