////
////  Assignment.swift
////  SwiftUIViewModelBuilder
////
////  Created by MohammavDev on 5/21/25.
////
//
//public protocol Expression : Sendable {}
//
//
//
//public extension Expression where Self == MathExpression{
//     static func plus( _ lhs:FeildType, _ rhs: FeildType) -> MathExpression {
//        
//        .init( lhs, .add, rhs)
//    }
//     static func equal( _ lhs:FeildType, _ rhs: FeildType) -> MathExpression {
//        .init( lhs, .add, rhs)
//    }
//    
//}
//
//public struct AssignmentInfo {
//    
//    let lhs : FeildType
//     
//    
//    
//}
//
//public enum MathOperator :String, CodeGeneratable{
//    
//    public var code: String {
//        rawValue
//    }
//    case equal = "==" , notEqual = "!=" , greaterThan = ">" , greaterThanOrEqual = ">=" , lessThan = "<" , lessThanOrEqual = "=<" , add = "+" , subtract = "-" , multiply = "*" , divide = "/"
//    
//}
//public struct MathExpression : Expression , CodeGeneratable{
//    
//    let firstPart : FeildType
//    let secondPart : FeildType
//    let `operator` : MathOperator
//    
//    public init(_ firstPart: FeildType , _ operator: MathOperator = .equal, _ secondPart: FeildType) {
//        self.firstPart = firstPart
//        self.secondPart = secondPart
//        self.operator = `operator`
//    }
//   
//    public static func plus( _ lhs:FeildType, _ rhs: FeildType) -> MathExpression {
//        .init( lhs, .add, rhs)
//    }
//    public static func equal( _ lhs:FeildType, _ rhs: FeildType) -> MathExpression {
//        .init( lhs, .equal, rhs)
//    }
//    
//    public var code: String {
//        "\(firstPart.code) \(`operator`.code) \(secondPart.code)"
//    }
//}
//
//let expr : Expression = .plus(12 , 14)
