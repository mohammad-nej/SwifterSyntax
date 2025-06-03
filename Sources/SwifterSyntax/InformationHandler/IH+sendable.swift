//
//  IH+sendable.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 6/1/25.
//

public extension InformationHandler{
    var sendable: InformationHandlerSendable{
       .init(from: self)
    }
}
