//
//  ObjectInformation.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/26/25.
//
import Foundation
import SwiftSyntax

public struct SendableObjectInformation : Identifiable , Sendable{
    final class _wrapper : Sendable{
        let vm : SendableObjectInformation?
        init(vm: SendableObjectInformation?) {
            self.vm = vm
        }
    }
     init(from object : ObjectInformation){
         self.conformances = object.conformances.map(\.self)
        self.name = object.name
        self.id = object.id
        self.availability = object.availability
        let feilds = object.fields.map(\.sendable)
         self.fields = feilds.map(\.self)
        self.sourceFile = object.sourceFile
        self.url = object.url
        self.type = object.type
        self._sendableObjectInformation = .init(vm: object.viewModel?.sendable)
    }
    ///All Variables of this type
    public let fields : [SendableField]
    
    ///Name of the type
    public let name : String
    
    ///class , struct , enum , actor, ...
    public let type : ObjectType
    
    ///public , private , ...
    public let availability : AccessLevel
    
    ///URL of the file which this type is located at.
    public let url : URL?
    
    ///Id
    public let id : UniqueID
    
    ///Parsed sourceFile of this file
    public let sourceFile : SourceFileSyntax?
    
    ///All protocol conformances/ inheritances for this class
    ///e.g. : Equatable , Sendable , ....
    public let conformances : [String]
    
    //Because ViewModel is also a ObjectInformation and a struct can't recurrsivly contain itself,
    //we use this wrapper class to wrap the ViewModel object
    private let _sendableObjectInformation : _wrapper
    
    ///SwiftUI view model found for this view
    public var viewModel : SendableObjectInformation? {
        _sendableObjectInformation.vm
    }
    
    
}
