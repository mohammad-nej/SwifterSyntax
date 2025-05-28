//
//  ViewInformation.swift
//  SwiftUIViewModelBuilder
//
//  Created by MohammavDev on 5/20/25.
//

///information about a specific SwiftUI view
public struct ViewInformation{
    
    public var name : String
    
    ///all SwiftUI views have to struct
    public let type : ObjectType = .struct
    
    ///all conformances of this view
    public var conformances : [String]
    
    ///View model for this view
    public var viewModel : ObjectInformation?
    
    ///All @State or @StateObject variables
    public lazy var stateVariables : [FeildType] = {
        allVariables.filter { $0.isStateVariable}
    }()
    
    ///All @Environment variables
    public lazy var environmentVariables : [FeildType] = {
        allVariables.filter { $0.isEnvironmentVariable}
    }()
    
    ///All normal variables like view inputs :
    ///```swift
    ///struct BookView : View {
    ///let name : String
    ///var body : some View {
    /// Text(name)
    ///}
    ///```
    ///this will return `name` variable
    public lazy var inputVariables : [FeildType] = {
        allVariables.filter{
            !$0.isStateVariable && !$0.isEnvironmentVariable && !$0.isStatic && !$0.isComputedProperty
        }
    }()
    
    ///list of all static variables of this view
    public lazy var staticVariables : [FeildType] = {
        allVariables.filter{ $0.isStatic }
    }()
    
    ///All of the computed variables in the view
    public lazy var computedVariables : [FeildType] = {
        allVariables.filter{ $0.isComputedProperty}
    }()
    
    ///public,private, ....
    let accessLevel : AccessLevel
    
    ///all macros and other attributes attached to the view : @MainActor, ...
    let attributes : [String]
    
    
    ///Mix of all variables in the view including environment variables, static and computed ones
    public var allVariables : [FeildType] = []
    
    public var hasViewModel : Bool {
        return viewModel != nil
    }
    
}
public extension ViewInformation{
    
    ///Connivance initializer to convert a normal ObjectInformation to a ViewInformation
    init?(objectInfo object : ObjectInformation){
        
        guard object.isView else { return nil}
        self.name = object.name
        self.conformances = object.conformances
        self.accessLevel = object.availability
        self.attributes = object.attributes
        self.allVariables = object.fields
        self.viewModel = object.viewModel

    }
    
}
