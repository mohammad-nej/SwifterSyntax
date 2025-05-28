//
//  InformationHandler.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/15/25.
//
import SwiftUI
@Observable
public final class InformationHandler : SendableCreatable {
    
     
    //preventing this class from being initialized directly
    //use InformationHandlerBuilder or .new static variable to create new instance
    fileprivate init(){}
     
    public enum FindingError : Error {
         case notFound
    }
     
     ///list of all global and static variables found in the source code
     public  var topLevelVariables : [FeildType] = []
     
     public var objects : Set<ObjectInformation> = []
    
    //List of all scopedURLs of directories got from the user, this should be release later on when we are done with it.
     public var scopedURLs : [URL] = []
     
    //List of all swift files that we have found
     public var swiftFiles : [URL] = []
     
    
     public var viewModels : [ObjectInformation : ObjectInformation] = [:]
     
     public func append(_ objectInformation : ObjectInformation) {
        self.objects.insert(objectInformation)
     }
    public func append(contentsOf types : [ObjectInformation] ){
        types.forEach { obje in
            self.objects.insert(obje)
        }
    }
     ///Find a Type by it's name, this will support passing arrays of a type or ? operator
     ///
     ///assuming :
     ///```swift
     ///struct Person{
     ///var name : String
     ///}
     ///```
     ///after extracting data you can use this function :
     ///```swift
     ///let person = find("Person")
     ///let personOptional = find("Person?")
     ///let personArray = find("[Person]")
     public  func find(_ typeName : String) -> ObjectInformation? {
         objects.first { type in
             type.name == typeName
         }
     }
     public func isClass(_ typeName : String) throws -> Bool {
         let findObject = find(typeName)
         
         guard let findObject else { throw FindingError.notFound}
         return findObject.type == .class
     }
     
     public func isStruct(_ typeName : String) throws -> Bool {
         let findObject = find(typeName)
         
         guard let findObject else { throw FindingError.notFound}
         return findObject.type == .struct
     }
     
     public func isEnum(_ typeName : String) throws -> Bool {
         let findObject = find(typeName)
         
         guard let findObject else { throw FindingError.notFound}
         return findObject.type == .enum
     }
     
     //String
     @ObservationIgnored
     public lazy var string : ObjectInformation = {
         objects.first { object in
             object.name == "String"
         }!
     }()
    
     
     
     //Double
     @ObservationIgnored
     public lazy var double : ObjectInformation = {
         objects.first { object in
             object.name == "Double"
         }!
     }()
    
     
     //Integer
     @ObservationIgnored
     public lazy var int : ObjectInformation = {
         objects.first { object in
             object.name == "Int"
         }!
     }()
 
     //UUID
     @ObservationIgnored
     public lazy var uuid : ObjectInformation = {
         objects.first { object in
             object.name == "UUID"
         }!
     }()
    

     //Bool
     @ObservationIgnored
     public lazy var bool : ObjectInformation = {
         objects.first { object in
             object.name == "Bool"
         }!
     }()
   
     //CGFLoat
     @ObservationIgnored
     public lazy var cgfloat : ObjectInformation = {
         objects.first { object in
             object.name == "CGFloat"
         }!
     }()
   
}

public extension InformationHandler{
    var viewsWithOutViewModel : [ObjectInformation]{
        objects.filter { object in
            guard object.isView else { return false}
            return hasViewModel(object) == false
        }
    }
    
//    Indicates whether a View already has a View Model or not?
    func hasViewModel(_ object : ObjectInformation) -> Bool {
       
        //we only care about view models inside views
        guard object.isView else { return false }
    
            //We should loop through all fields in a view to see if there is
            //any view model in it or not ?
            for field in object.fields {
                let object = field.type
                guard let object else { continue}
                if object.isViewModel{
                    return true
                }
                
            }
            return false
        }
    
}

public extension InformationHandler{
    
    ///Creates and insert a new ObjectInformation inside this handler
    func CreateNewType(name : String , type : ObjectType) -> ObjectInformation{
        
        let newType = ObjectInformation(type: type, info: self)
        newType.name = name
        
        self.append(newType)
        
        return newType
    }
    
}

public extension InformationHandler{

    ///a sample for xcode previews
    ///
    internal static var emptySample : InformationHandler {
        .init()
    }
    
    internal static var sample : InformationHandler {
        let handler = InformationHandler.new
        
        //Creating a sample view for handler
        let sampleView1 = ObjectInformation(type: .struct, info: handler)
        sampleView1.name = "SampleView1"
        sampleView1.availability = .internal
        sampleView1.conformances = ["View"]
        let variables : [FeildType] = [
            .init(name: "name", type: handler.string, attributes: ["@State"], mutationType: .var, initialValue: "Mohammad", isComputedProperty: false, modifiers: ["private"], accessLevel: .internal),
            .init(name: "age", type: handler.int, attributes: ["@State"], mutationType: .var, initialValue: "24", isComputedProperty: false, modifiers: ["private"], accessLevel: .internal),
            .init(name: "mock", type: handler.bool, attributes: [], mutationType: .let, initialValue: "false", isComputedProperty: false, modifiers: [], accessLevel: .private),
            .init(name: "body", type: .fromString("some View", using: handler), attributes: [], mutationType: .var, initialValue: "", isComputedProperty: true, modifiers: [], accessLevel: .internal),
        ]
        sampleView1.fields = variables
        
        //inserting to the handler
        handler.append(sampleView1)
        
        //Creating another sample view
        let sampleView2 = ObjectInformation(type: .struct, info: handler)
        sampleView2.name = "SampleView2"
        sampleView2.conformances = ["View"]
        sampleView2.availability = .internal
        let variables2 : [FeildType] = [
            .init(name: "family", type: handler.string, attributes: ["@State"], mutationType: .var, initialValue: "Nej", isComputedProperty: false, modifiers: ["private"], accessLevel: .internal),
            .init(name: "isMarried", type: handler.bool, attributes: ["@State"], mutationType: .var, initialValue: "false", isComputedProperty: false, modifiers: ["private"], accessLevel: .internal),
            .init(name: "mock", type: handler.bool, attributes: [], mutationType: .let, initialValue: "false", isComputedProperty: false, modifiers: [], accessLevel: .private),
            .init(name: "body", type: .fromString("some View", using: handler), attributes: [], mutationType: .var, initialValue: "", isComputedProperty: true, modifiers: [], accessLevel: .internal),
            .init(name: "coordinator", type: .fromString("Coordinator", using: handler), attributes: ["@Environment"], mutationType: .var, initialValue: "", isComputedProperty: false, modifiers: ["private"], accessLevel: .private)
        ]
        sampleView2.fields = variables2
        
        handler.append(sampleView2)
        
        return handler
    }
}


//Builder here
///Builder for InformationHandler which injects some Hard-Coded data into InformationHandler such as String, Int , ...
struct InfromationHandlerBuilder{
    
    
    private let infoHandler = InformationHandler()

    
    fileprivate  var stringInformation : ObjectInformation  {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
        
        info.name = "String"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Comparable","Hashable" , "Equatable",
                             "CustomStringConvertible", "CustomDebugStringConvertible",
        ]

        return info
    }
    fileprivate  var intInformation : ObjectInformation {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
        
        info.name = "Int"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Comparable" , "Equatable",
                             "CustomStringConvertible", "Hashable"
        ]
 
        return info
    }
    
    fileprivate  var doubleInformation : ObjectInformation  {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
        
        
        info.name = "Double"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Comparable" , "Equatable",
                             "CustomStringConvertible", "Hashable"
        ]
        return info
    }
    
    fileprivate  var cgfloatInformation : ObjectInformation  {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
        
        
        info.name = "CGFloat"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Comparable" , "Equatable",
                             "CustomStringConvertible", "Hashable"
        ]
        return info
    }
    fileprivate  var boolInformation : ObjectInformation {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
        
        info.name = "Bool"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Equatable",
                             "CustomStringConvertible", "Hashable"
        ]

        return info
    }
    fileprivate   var dateInformation : ObjectInformation  {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
       
        
        
        info.name = "Date"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Equatable", "Comparable",
                             "CustomStringConvertible", "Hashable",
                             "Equatable"
                             
        ]

        return info
    }
    fileprivate  var uuidInformation : ObjectInformation  {
        
        var info = ObjectInformation(type: .struct, info: infoHandler)
        var isOk : Bool = false
        
        info.name = "UUID"
        info.availability = .public
        info.conformances = ["Codable" , "Sendable" , "Equatable",
                             "CustomStringConvertible", "Hashable"
        ]
        return info
    }
    
    
    

    func build() -> InformationHandler{
        let types =  [
            stringInformation,
            dateInformation ,
            uuidInformation,
            doubleInformation,
            boolInformation,
            intInformation,
            cgfloatInformation
        ]
        types.forEach { obj in
            infoHandler.append(obj)
        }
        
        addDefaultVariables(info: infoHandler)
        return infoHandler
    }
    
    func addDefaultVariables(info : InformationHandler){
        for index in info.objects.indices {
            
            //adding .description to all types
            info.objects[index].fields.append(.computedProperty(name: "description", type: info.string ))
            
            
            if info.objects[index].name == "UUID"{
                let uuidString = ComputedPropertyBuilder(name: "uuidString", type: info.string)
                    .accessLevel(.public)
                    .build()
                info.objects[index].fields.append(uuidString)
            }
            
            if info.objects[index].name == "CGFloat"{
                let pi =
                ComputedPropertyBuilder(name: "pi", type: info.cgfloat)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()
                let zero = ComputedPropertyBuilder(name: "pi", type: info.cgfloat)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()

                let staticVariables : [FeildType] = [pi,zero]
                
                info.objects[index].staticVariables.append(contentsOf: staticVariables)
            }
            
            if info.objects[index].name == "Double"{
                let pi =
                ComputedPropertyBuilder(name: "pi", type: info.double)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()
                let zero = ComputedPropertyBuilder(name: "pi", type: info.double)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()

                let infinity = ComputedPropertyBuilder(name: "infinity", type: info.double)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()
                let staticVariables : [FeildType] = [pi,zero,infinity]
                
                info.objects[index].staticVariables.append(contentsOf: staticVariables)
            }
            
            if info.objects[index].name == "Int"{
                let min =
                ComputedPropertyBuilder(name: "min", type: info.int)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()
                let max = ComputedPropertyBuilder(name: "max", type: info.int)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()

                let zero = ComputedPropertyBuilder(name: "zero", type: info.int)
                    .accessLevel(.public)
                    .isStatic(true)
                    .build()
                let staticVariables : [FeildType] = [min,zero,max]
                
                info.objects[index].staticVariables.append(contentsOf: staticVariables)
            }
            
            if info.objects[index].name == "String"{
       
                let isEmpty = ComputedPropertyBuilder(name: "isEmpty", type: info.bool)
                    .accessLevel(.public)
                    .build()
                let capitalized = ComputedPropertyBuilder(name: "capitalized", type: info.string)
                    .accessLevel(.public)
                    .build()
                let count = ComputedPropertyBuilder(name: "count", type: info.int)
                    .accessLevel(.public)
                    .build()
                
                let feilds : [FeildType] = [isEmpty,capitalized,count]
                info.objects[index].fields.append(contentsOf: feilds)
            }
            
            
        }
        
        
        
    }
}

public extension InformationHandler{
    
    static var new : InformationHandler {
        InfromationHandlerBuilder().build()
    }
    
}
public extension InformationHandler{
    enum TypeVariation {
        case normal //Person
        case optional //Person?
        case array //[Person]
        case arrayOfOptionals //[Person?]
        case optionalArray //[Person]?
        case optionalArrayOfOptionals  // [Person?]?
        
        init(from string : String){
            var copy  = string
            var temporalSelf = TypeVariation.normal
            
            if copy.hasSuffix("?"){
                temporalSelf = .optional
                copy.removeLast()
                if copy.hasSuffix("]"){
                    copy.removeLast()
                    temporalSelf = .optionalArray
                    if copy.hasSuffix("?"){
                        temporalSelf = .optionalArrayOfOptionals
                    }
                }
            }else if copy.hasSuffix("]"){
                temporalSelf = .array
                copy.removeLast()
                if copy.hasSuffix("?"){
                    temporalSelf = .arrayOfOptionals
                }
           }
           self = temporalSelf
        }
       }
    
     var sendable: InformationHandlerSendable{
        .init(from: self)
    }
}
