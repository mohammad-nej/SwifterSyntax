//
//  ObjectType.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/13/25.
//

public enum BaseSwiftVariableTypes : String ,Sendable, CaseIterable , Identifiable , CodeGeneratable{
    public var id: Self { self }
    public var code : String { rawValue }
    case `String`, `Int`, `Bool`, `Float`, `Double` , `UUID`
}

public enum ObjectType : String ,Sendable, CaseIterable , Identifiable, CodeGeneratable {
    public var id : Self { self}
    public var code : String {
        guard self != .unknown else {
            return "Unkonow type ! "
        }
        return rawValue
    }
    case `struct`,`class`,`enum`, `actor`,`protocol` ,unknown
}

public enum AccessLevel : String,Sendable, CaseIterable , Identifiable, CodeGeneratable {
    public var id : Self { self}
    public var code : String {
        guard self != .internal else{
             return ""
        }
        return rawValue
    }
    case `public`, `internal`, `fileprivate`, `private`,`open`
    
    init(from rawValue: [String]) {
        for value in rawValue {
            switch value {
            case "public":
                self = .public
                return
            case "internal":
                self = .internal
                return
            case "fileprivate":
                self = .fileprivate
                return
            case "private":
                self = .private
                return
            default:
                continue
            }
        }
        self = .internal
    }
}

public enum MutationType : String ,Sendable, CaseIterable , Identifiable, CodeGeneratable {
    public var id: Self { self }
    case `var` , `let`
    
    public var code : String {
        rawValue
    }
}




