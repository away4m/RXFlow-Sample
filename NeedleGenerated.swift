

import Foundation
import NeedleFoundation
import RxFlow

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootDIComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootDIComponent->AppFlowDI") { component in
        return AppFlowDependencyedc608544694b04b5699Provider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootDIComponent->InteractorDIComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    
}

// MARK: - Providers

/// ^->RootDIComponent->AppFlowDI
private class AppFlowDependencyedc608544694b04b5699Provider: AppFlowDependency {
    var interactorDI: InteractorDIComponent {
        return rootDIComponent.interactorDI
    }
    private let rootDIComponent: RootDIComponent
    init(component: NeedleFoundation.Scope) {
        rootDIComponent = component.parent as! RootDIComponent
    }
}
