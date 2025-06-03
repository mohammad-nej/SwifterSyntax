//
//  InitializerType.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//

import Foundation

public final class InitializerType : UniqueIDable,CodeGeneratable , ExtensionIncludable,Identifiable, Equatable , Hashable {
    
    public init(for type : ObjectInformation){
        self.type = type
    }
    
    public var id = UniqueID()
    
    ///The type which this initializer is initializing
    public weak var type : ObjectInformation?
    
    ///the Extension which this initializer is included in (if any)
    public weak var parentExtension : ExtensionInformation?
    
    ///is this initializer nullable?
    public var isNullable = false
    
    ///inputs of this initializer
    public var inputs : [FunctionInformation.FunctionInput] = []
    
    ///private , public , ...
    public var accessLevel : AccessLevel = .unknown
    
    ///modifiers of this initializer : static , lazy , ...
    public var modifiers : [String] = []
    
    ///is it async?
    public var isAsync = false
    
    ///is it throwing?
    public var isThrowing = false
    
    ///swift code inside this initializer
    public var innerSourceCode : String?
}


public extension InitializerType {
    
    ///URL which this initializer definition is located at
    var url : URL? {
        if let parentExtension , let url = parentExtension.url {
            return url
        }
        if let type , let url = type.url {
            return url
        }
        return nil
    }
}
