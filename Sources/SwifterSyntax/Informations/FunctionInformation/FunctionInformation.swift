//
//  FunctionInformation.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/28/25.
//

import Foundation
import OrderedCollections

public final class FunctionInformation : UniqueIDable, CodeGeneratable,ExtensionIncludable , Identifiable , Hashable , Equatable {

    
    ///Id
    public var id : UniqueID = .init()
    
    ///Name of the function
    public var name : String
    
    
    
    ///the Extension which this function is defined in ( if any)
    public weak var parentExtension: ExtensionInformation?
    
    ///Source code inside the function
    public var innerSourceCode : String?
    
    ///private , public , ....
    public var accessLevel : AccessLevel = .unknown
    
    ///static , ...
    public var modifiers : OrderedSet<String> = []
    
    public var isThrowing = false
    
    public var isAsync = false
    
    ///Input parameters of the function
    public var intputTypes : [FunctionInput]
    
    ///Output type of the function, can be nil for void
    public weak var returnType : ObjectInformation?
    
    ///Indicates the type which this function belongs to
    ///
    /// - Note: Global functions don't have parent
    public weak var parent : ObjectInformation?
    
    public init(name : String , intputTypes : [FunctionInput] , returnType : ObjectInformation? = nil) {
        self.name = name
        self.intputTypes = intputTypes
        self.returnType = returnType
    }
    
    
}

public extension FunctionInformation{
    
    ///URL which this function is located at
    var url : URL?{
        //if it's in an extension
        if let parentExtension{
            if let url = parentExtension.url{
                return url
            }
        }
        
        //if it's directly in main type definition
        if let parent{
            if let url = parent.url{
                return url
            }
        }
        //just in case
        return nil
    }
    
    
}
