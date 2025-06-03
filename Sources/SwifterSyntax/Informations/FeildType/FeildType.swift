//
//  FeildType.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/15/25.
//

import Foundation
import OrderedCollections

///Holds information about your variables, including their name , type , mutationType(var/let) , initialValue , ...
///
public final class FeildType :  UniqueIDable,SendableCreatable, ExtensionIncludable,Identifiable ,CodeGeneratable , Hashable , Equatable {
   

    /// id used for Hashable , Equatable
    public var id : UniqueID = .init()
    
    ///Name of the variable
    public let name : String
    
    ///typed of variable like Int,String,... , can be nil if we are unable to infer the type
    public weak var type : ObjectInformation?

    ///type which this variable is a property of, otherwise nil
    public weak var parentType : ObjectInformation?
    
    ///The extension which this vairable is located in, otherwise nil
    public weak var parentExtension: ExtensionInformation?
    
    ///Computed variables can have source code inside them, otherwise nil
    public var innerSourceCode : String? = nil
    
    ///macros like @Observable or @State , ...
    public var attributes : OrderedSet<String> = []
    
    ///var or let, thats the question!
    public var mutationType : MutationType
    
    
    ///initial value provided when declaring the variable.
    ///
    ///Some variables might not have initialValue e.g. computed properties or the initialValue
    ///might not be explicit for example in SwiftUI all EnvironmentKeys has a default value, but it's not explicitly written in text
    ///
    /// - Warning: For Optional variables if the initialValue is nil , it will be specified by "nil" string, if this variable value is nil it means that
    /// initialValue was undetectable. e.g. computed properties can't have initialValue.
    ///
    /// - Note: Use `isNil` to detect if variable initialValue is nil or not.
    public let initialValue : InputLitteral?
    
    ///indicates whether it's a computed property or not ?
    public  var isComputedProperty : Bool
 
    ///static , private ,...
    public var modifiers : OrderedSet<String>
  
    ///private,public,....
    public var accessLevel : AccessLevel
    
    public init(name: String, type: ObjectInformation?, attributes: [String], mutationType: MutationType, initialValue: InputLitteral?, isComputedProperty: Bool, modifiers: [String], accessLevel: AccessLevel) {
        self.name = name
        self.type = type
        
        self.attributes = .init(attributes)
        self.mutationType = mutationType
        self.initialValue = initialValue
        self.isComputedProperty = isComputedProperty
        self.modifiers = .init(modifiers)
        self.accessLevel = accessLevel
    }
}


