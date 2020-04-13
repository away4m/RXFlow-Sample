//
import RxCocoa
import RxFlow
import RxSwift
//  AppDelegate.swift
//  Stocks
//
//  Created by ALI KIRAN on 11.04.20.
//  Copyright © 2020 ALI KIRAN. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Needle DI
        registerProviderFactories()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        coordinator.rx.willNavigate.subscribe(onNext: { flow, step in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: disposeBag)
        
        coordinator.rx.didNavigate.subscribe(onNext: { flow, step in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: disposeBag)
        
        let rootComponent = RootDIComponent()
        let appFlow = rootComponent.appFlow
        Flows.whenReady(flow1: appFlow) { root in
            self.window?.rootViewController = root
            self.window?.makeKeyAndVisible()
        }
        
        coordinator.coordinate(flow: appFlow, with: AppStepper())
        
        return true
    }
}
