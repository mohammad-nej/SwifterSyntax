//
//  InformationHandlerSendable.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/26/25.
//
import SwiftSyntax
import Foundation

///Sendable type for InformationHandler , useful when you want to send InformationHandler across thread boundaries
///
///You can use .sendable property on `InformationHandler` to create an instance of this type
///```swift
///let info = InformationHandler.new
/////do your stuff here
/////...
///let sendableInfo = info.sendable
///```
public struct InformationHandlerSendable : Sendable {
    
    init(from info : InformationHandler){
        self.bool = info.bool.sendable
        self.cgFloat = info.cgfloat.sendable
        self.double = info.double.sendable
        self.int = info.int.sendable
        self.string = info.string.sendable
        self.uuid = info.uuid.sendable
        
        self.swiftFiles = info.swiftFiles
        self.topLevelVariables = info.topLevelVariables.map(\.sendable)
        self.types = info.objects.map(\.sendable)
    }
    
    ///Global variables found in the source code
    public let topLevelVariables : [SendableField]
    
    ///All types found in the source code + some swift base types like String,Int,Bool,UUID , ...
    public let types : [SendableObjectInformation]
    
    ///URL of all the swift files used to extract these informations
    public let swiftFiles : [URL]
    
    ///Use this to compare against Int types
    public let int : SendableObjectInformation
    
    ///Use this to compare against String types
    public let string : SendableObjectInformation
    
    ///Use this to compare against Bool types
    public let bool : SendableObjectInformation
    
    ///Use this to compare against Double types
    public let double : SendableObjectInformation
    
    ///Use this to compare against UUID types
    public let uuid : SendableObjectInformation
    
    ///Use this to compare against CGFloat types
    public let cgFloat : SendableObjectInformation
}


