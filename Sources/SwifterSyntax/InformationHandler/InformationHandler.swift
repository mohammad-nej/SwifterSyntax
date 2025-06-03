//
//  InformationHandler.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/15/25.
//
import SwiftUI
import OrderedCollections
@Observable

///Holds information about all Types and Variables found in your code base
public final class InformationHandler : SendableCreatable {
    
    
    //preventing this class from being initialized directly
    //use InformationHandlerBuilder or .new static variable to create new instance
    /// Meant to be used **only** by InformationHandlerBuilder
    ///
    ///  - Warning: Don't use this initializer directly, use `.new` or `InformationHandlerBuilder` instead.
    internal init(){}
    
    public enum FindingError : Error {
        case notFound
    }
    
    ///list of all global and static variables found in the source code
    public  var topLevelVariables : OrderedSet<FeildType> = []
    
    //list of all global functions found in the source code
    public var topLevelFunctions : OrderedSet<FunctionInformation> = []
    
    ///Indicates whether this infoHandler need a rerun or not
    ///
    ///Because when we are inferring types, we parse source code in order,
    ///the order of files might affect our inference. for example:
    ///file1 :
    ///```swift
    ///var personName = myPerson.name
    ///```
    ///file2:
    ///```swift
    ///struct Person{
    ///  var name : String
    ///}
    ///var myPerson = Person(name : "Mohammad")
    ///```
    ///if we parse `file2` first, then by the time we reach `file1` we already know `myPerson`s type thus
    ///we can infer `personName` type, but if we parse `file1` first, then `file2`, we can't infer the type of
    ///`personName` variable cause `myPerson` is not visited yet.
    ///
    ///to go around this problem, on the first run, if we can't infer the type of a variable it will be nil
    /// then we parse the entire code a second time (using the same `InformationHandler`, thus keeping our previous knowledge).
    /// this trick will make the order of files irrelevant.
    internal var needRerun : Bool = false
    
    ///List of all the source that need rerun
    ///
    ///If a part of code need a reRun , it will be stored in here so that it will be parsed again using `reRun` function.
    ///
    ///Check `needRerun` variable for more information about reRun
    internal var codesToRerun : Set<CodeInfo> = []
    
    ///All the types found in swift source code
    public var objects : OrderedSet<ObjectInformation> = []
    
    //List of all scopedURLs of directories got from the user, this should be release later on when we are done with it.
    public var scopedURLs : [URL] = []
    
    //List of all swift files that we have found
    public var swiftFiles : [URL] = []
    
    ///List of all extensions found in the source code
    public var extensions : OrderedSet<ExtensionInformation> = []
    
    public var viewModels : [ObjectInformation : ObjectInformation] = [:]
    
    
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











