

import Foundation
import NeedleFoundation
import RxCocoa
import RxFlow
import RxSwift
import UIKit

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootDIComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootDIComponent->InteractorDIComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootDIComponent->AppFlowConfiguration") { component in
        return AppFlowDependency5fc755ce4a05eb90346dProvider(component: component)
    }
    
}

// MARK: - Providers

/// ^->RootDIComponent->AppFlowConfiguration
private class AppFlowDependency5fc755ce4a05eb90346dProvider: AppFlowDependency {
    var interactorDI: InteractorDIComponent {
        return rootDIComponent.interactorDI
    }
    private let rootDIComponent: RootDIComponent
    init(component: NeedleFoundation.Scope) {
        rootDIComponent = component.parent as! RootDIComponent
    }
}
