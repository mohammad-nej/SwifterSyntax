//
//  TestClass.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/14/25.
//
import SwiftUI


///This class is mainly used as a test for testing the package
@Observable class Person  : Empty{
    var name : String = "Mohammad"
     var age : Int = 14
    var feild : TestObject = .init()
}
 struct TestObject{
    let id = 5
}

protocol Empty{}
