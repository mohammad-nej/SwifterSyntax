//
//  ObjectInformation.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/15/25.
//

import Foundation
import SwiftSyntax

///Holds information about Types found in your code base.
///
///You can create a new type for yourself using provided static variables e.g. ``ObjectInformation.class`` , ``ObjectInformation.struct``
public final class ObjectInformation :SendableCreatable, Identifiable , Hashable , Equatable {
    

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public weak var informationHandler : InformationHandler?
    
    ///Unique identifier for the class
    public let id = UUID()
    
    ///URL of where the main declaration located at
    public var url : URL?
    
    //Type of the object : Enum,Struct ,Class , Actor,...
    public var type : ObjectType
    
    ///Name of the object : e.g. : Class Person{ -> Person
    public var name : String = ""
    
    //public , private , ...
    public var availability : AccessLevel
    
    public var hasNoArgumentInitializer : Bool
    
    ///Main source code all this info is extracted from
    public var sourceFile : SourceFileSyntax?
    
    ///Any macro/property wrapper attached to the class :
    ///```swift
    ///@Observable class Person{
    ///```
    ///this will return "@Observable"
    public var attributes : [String] = []
    
    ///all inheritance/protocols that this type conforms to like Equatable , Sendable , ....
    public var conformances : [String] = []
    
    ///returns all @State variables inside a SwiftUI view
    lazy var allStateVariables : [FeildType]  = {
        guard isView else { return [] }
        
        return fields.filter { field in
            field.isStateVariable
        }
    }()
    
    
    
    ///indicated whether does this object has a ViewModel or not ?!
    public var viewModel : ObjectInformation?
    
    ///all variables inside the object
    public var fields : [FeildType] = []
    
    ///All static variables inside the object
    public lazy var staticVariables : [FeildType]  = {
        fields.filter { $0.isStatic }
    }()
    
    ///Person -> [Person?]
    public var  arrayOfOptionals : ObjectInformation? {
        
        guard let info = informationHandler else { return nil}
        
        ///if current type is optional we just don't want to add another ? in front of the type name
        let name = self.isOptional ? self.name.removeLast().description : self.name
        
        if let arrayOfOptionals = info.find("[" + name + "?]" ){
            return arrayOfOptionals
        }
        return self.optional?.array
        
    }
    
    ///Person -> [Person]?
    public var optionalArray : ObjectInformation? {
        guard let info = informationHandler else { return nil}
        
        
        let name = self.name
        
        if let optionalArray = info.find("[" + name + "]?" ){
            return optionalArray
        }
        
        return  self.array?.optional
    }
    
    ///Person -> [Person?]?
    public var optionalArrayOfOptionals : ObjectInformation? {
        
        guard let info = informationHandler else { return nil}
        
        ///if current type is optional we just don't want to add another ? in front of the type name
        let name = self.isOptional ? self.name.removeLast().description : self.name
        
        if let optionalArrayOfOptionals = info.find("[" + name + "?]?" ){
            return optionalArrayOfOptionals
        }
        return self.optional?.array?.optional
    }
    
    ///Person -> [Person]
    public var array : ObjectInformation? {
        guard let info = informationHandler else { return nil}
        
        //if we have already created an array type for this type, we just return it
        if let array =  info.find("[" + self.name + "]" ){
            return array
        }
        
        //deep copying
        let copy = ObjectInformation(type: .struct,info: info) //arrays are Struct in swift
        
        //inserting array type into the InformationHandler for later use
        info.append(copy)
        copy.name = "[" +  self.name + "]"
        copy.fields = [
            .computedProperty(name: "first", type: self.optional! ),
            .computedProperty(name: "last", type: self.optional!),
        ]
        copy.url = nil
        copy.attributes = []
        copy.conformances = []
        copy.viewModel = nil
        return copy
    }
    
    ///Person -> Person?
    public  var optional : ObjectInformation?  {
        guard let info = informationHandler else { return nil}
        
        ///if this type is already an optional , we just return itself
        guard !self.isOptional else { return self}
        
        //if we have already created an optional type for this type , we just return it
        if let optional =  info.find(self.name + "?"){
            return optional
        }
        
        let copy = self.deepCopy()
        guard let copy else { return nil}
        
        //inserting optional type into the InformationHandler for later use
        info.append(copy)
        
        copy.name += "?"
        return copy
    }
    
    
    
    public init(type : ObjectType, info : InformationHandler){
        self.type = type
        self.informationHandler = info
        self.availability = .public
        hasNoArgumentInitializer = false
        self.informationHandler = info
        self.fields = []
    }
    
}

extension ObjectInformation {
    
    /// Convince method to infer your type from a given string, can be use to infer most common swift types like String, Bool, Int
    ///  arrays and optionals created from these types and much more. will return nil if inferring is failed
    /// - Parameters:
    ///   - value: your type name
    ///   - info: Use this informationHandler to search for your requested type
    /// - Returns: type of your variable if found, otherwise nil
    public static func infer(from value : String, using info : InformationHandler ) -> ObjectInformation?{
      
        info.find(value)
    }
    
    
    /// Tries to infer the type based on the `string` parameter, if it fails it will create a new  type and return it
    /// - Parameters:
    ///   - string: "name of the type we are looking for"
    ///   - type: "Type of the object that will be created if it fails to infer the type "
    ///   - info: "informationHandler object that is used to infer the type"
    /// - Returns: inferred type if possible, otherwise will create a new type
    public static func fromString(_ string : String, type : ObjectType = .struct , using info : InformationHandler ) -> ObjectInformation {
        if let infered = infer(from: string,using: info) {
            return infered
        }
        
        let newObject = ObjectInformation(type: type,info: info)
        newObject.name = string
        newObject.informationHandler = info
        info.objects.insert(newObject)
        return newObject
    }
    
}

public extension ObjectInformation {
    
    ///Indicates whether the type is an array or not?
    var isArray : Bool {
        
        return (self.name.hasSuffix("]") || self.name.hasSuffix("]?")) && //an optional array is also an array -> [Person]?
            name.hasPrefix("[")
    }
    
    ///Indicates whether the type is  optional or not?
    var isOptional : Bool {
        return name.hasSuffix("?")
    }
    
    ///Indicate whether the object is a  SwiftUI view or not?
    var isView : Bool {
        conformances.contains("View")
    }

    
    //Determines whether the object is a SwiftUI View Model or not?
    var isViewModel : Bool {
        //all view models must be class
        guard type == .class else { return false}
        
        //all should either confrom to ObservableObject or  use @Observable macro
        if conformances.contains("ObservableObject") {
            return true
        }
        
        if attributes.contains("Observable"){
            return true
        }
        return false
    }
    
}


extension ObjectInformation {
    public static func == (lhs: ObjectInformation, rhs: ObjectInformation) -> Bool {
        return lhs.id == rhs.id
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

