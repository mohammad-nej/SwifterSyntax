//
//  AccessLevel.swift
//  SwifterSyntax
//
//  Created by MohammavDev on 5/29/25.
//

public struct AccessLevel : CodeGeneratable , InExtensionCodeGeneratable , Sendable ,Equatable , Hashable   {
    
    public init(_ type : AccessLevelEnum){
        self.type = type
    }
    public init(from rawValue: [String]) {
        for value in rawValue {
            switch value {
            case "public":
                self.type = .public
                return
            case "internal":
                self.type = .internal
                return
            case "fileprivate":
                self.type = .fileprivate
                return
            case "private":
                self.type = .private
                return
            default:
                continue
            }
        }
        self.type = .unknown
    }
    
    ///current AccessLevel
    public var type : AccessLevelEnum
    
    ///In case that this object/variable/function is inside an extension, this wil be the accessLevel of the parent extension
    public var parentAccessLevel : AccessLevelEnum? = nil
    
    
}
