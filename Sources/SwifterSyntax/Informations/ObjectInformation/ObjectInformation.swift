//
//  ObjectInformation.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/15/25.
//

import Foundation
import SwiftSyntax
import OrderedCollections
///Holds information about Types found in your code base.
///
///You can create a new type for yourself using provided static variables e.g. ``ObjectInformation.class`` , ``ObjectInformation.struct``
@DebugDescription
public final class ObjectInformation :UniqueIDable,SendableCreatable, ExtensionIncludable ,Identifiable , Hashable , Equatable {
    

    
    public weak var informationHandler : InformationHandler?
    
    ///Unique identifier for the class
    public var id = UniqueID()
    
    ///Initializers defined for this type
    public var initializers : OrderedSet<InitializerType> = []
    
    ///The extension which this type is defined in, if any , otherwise nil
    public weak var parentExtension : ExtensionInformation?
    
    ///Types defined inside this type
    public var innerTypes : OrderedSet<ObjectInformation> = []
    
    ///Type that is the parent of this type
    ///
    ///You can create a type inside another type in swift
    ///```swift
    ///struct Person{
    /// struct PersonalInfo{
    ///     var name : String
    ///     var family : String
    /// }
    /// let info : PersonalInfo
    /// //...
    ///}
    ///```
    ///in this case ,`Person` is the parentType of `PersonalInfo`, and `PersonalInfo`
    ///is included to the `innerTypes` of `Person`
    public weak var parentType : ObjectInformation?
    
    ///URL of where the main declaration located at
    public var url : URL?
    
    //Type of the object : Enum,Struct ,Class , Actor,...
    public var type : ObjectType
    
    ///Name of the object : e.g. : Class Person{ -> Person
    public var name : String = ""
    
    ///all functions found inside this type
    public var functions : OrderedSet<FunctionInformation> = []
    
    //public , private , ...
    public var availability : AccessLevel
    
   
    
    ///Main source code all this info is extracted from
    public var sourceFile : SourceFileSyntax?
    
    ///Any macro/property wrapper attached to the class :
    ///```swift
    ///@Observable class Person{
    ///```
    ///this will return "@Observable"
    public var attributes : OrderedSet<String> = []
    
    ///all inheritance/protocols that this type conforms to like Equatable , Sendable , ....
    public var conformances : OrderedSet<String> = []
    
    ///returns all @State variables inside a SwiftUI view
    public  var allStateVariables : [FeildType]   {
        guard isView else { return [] }
        
        return fields.filter { field in
            field.isStateVariable
        }
    }
    
    ///All extensions found in the source code
    public var extensions : OrderedSet<ExtensionInformation> = []
    
    ///indicated whether does this object has a ViewModel or not ?!
    public var viewModel : ObjectInformation?
    
    
    ///all variables inside the object
    public private(set) var fields : OrderedSet<FeildType> = []
    
    ///All static variables inside the object
    public  var staticVariables : [FeildType]  {
        fields.filter { $0.isStatic }
    }
    
   
    
    
    public init(type : ObjectType, info : InformationHandler){
        self.type = type
        self.informationHandler = info
        self.availability = .unknown
        
        self.informationHandler = info
        self.fields = []
    }
    
}




public extension ObjectInformation{
    func findVariable(named : String) -> FeildType? {
        for variable in fields {
            if variable.name == named {
                return variable
            }
        }
        return nil
    }
}

public extension ObjectInformation{
    
    func append(_ variable : FeildType){
        self.fields.upsert(variable)
        variable.parentType = self
    }
    
    func append(_ variables : [FeildType]){
        self.fields.upsert(variables)
        variables.forEach { $0.parentType = self }
    }
}
