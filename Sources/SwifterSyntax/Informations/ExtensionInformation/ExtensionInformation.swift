//
//  ExtensionInformation.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/28/25.
//

import Foundation
import OrderedCollections


public final class ExtensionInformation : UniqueIDable, CodeGeneratable , Identifiable , Hashable , Equatable {
    
    
    
    public var id : UniqueID = .init()
    
    ///the type which this extension is extending
    public var type : ObjectInformation
    
    public var url : URL? = nil
    
    private var _innerTypes : OrderedSet<ObjectInformation> = []
    ///Types created inside this extension
    public var innerTypes : OrderedSet<ObjectInformation> { _innerTypes }
    
    ///modifiers of this extension : static , lazy , ...
    public var modifiers : OrderedSet<String> = []
    
    ///public , private , ....
    public var accessLevel : AccessLevel = .internal
    
    private var _conformances : OrderedSet<String> = []
    ///conformances defined on this extension
    public var conformances : OrderedSet<String> { _conformances}
    
    private var _fields : OrderedSet<FeildType> = []
    ///Variables defined in this extension
    public var fields : OrderedSet<FeildType> { _fields }
    
    
    private var _functions : OrderedSet<FunctionInformation> = []
    ///Functions defined in this extension
    public var functions : OrderedSet<FunctionInformation> { _functions }
    
    private var _initializers : OrderedSet<InitializerType> = []
    ///Initiailizers defined in this extension
    public var initializers : OrderedSet<InitializerType> { _initializers }
    
    public init(of type : ObjectInformation) {
        self.type = type
    }
    
}
public extension ExtensionInformation{
     func append(_ element : FeildType){
        
        //if a variable doesn't have an accessLevel(private,public) inside an extension
        //it will inherit extensions accessLevel
        if element.accessLevel == .unknown{
            element.accessLevel = self.accessLevel
        }
         _fields.upsert(element)
        element.parentExtension = self
        //since this field is inside an extension, we should also add it to the extended type feilds
        type.append(element)
    }
    
    func append(_ element : FunctionInformation){
        if element.accessLevel == .unknown{
            element.accessLevel = self.accessLevel
        }
        _functions.upsert(element)
        
        element.parentExtension = self
        type.functions.upsert(element)
    }
    
    func append(_ conformance : String){
        _conformances.upsert(conformance)
        type.conformances.upsert(conformance)
    }
    
    func append(_ type : ObjectInformation){
        if type.availability == .unknown{
            type.availability = self.accessLevel
        }
        _innerTypes.upsert(type)
        type.parentExtension = self
        type.innerTypes.upsert(type)
        
        //if a Type (PersonalInfo) is declared inside an extension of a type(Person)
        //then the Person is the parent type of PersonalInfo
        self.type.innerTypes.upsert(type)
        type.parentType = self.type
    }
    func append(_ initalizer : InitializerType) {
        if initalizer.accessLevel == .unknown{
            initalizer.accessLevel = self.accessLevel
        }
        _initializers.upsert(initalizer)
        initalizer.parentExtension = self
        type.initializers.upsert(initalizer)
    }
}
