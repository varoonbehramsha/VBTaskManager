//
//  RootNavigationCoordinator.swift
//  VBTaskManager
//
//  Created by Varoon Behramsha on 05/07/19.
//  Copyright © 2019 Varoon Behramsha. All rights reserved.
//

import Foundation
import UIKit

enum NavigationMode
{
    case present, show
}

enum NavigationState
{
    case showingTaskList,
    showingTaskDetails,
    presentingTaskDetails
}

protocol Navigable
{
    var navigationState : NavigationState { get }
    func navigateTo(_ destinationVC : UIViewController,usingNavigationMode : NavigationMode)
    func goBack()
}

protocol RootNavigationCoordinatorProtocol
{
    func showTaskDetails(task:VBTaskDTO,delegate:VBTaskDetailsVCDelegate)
   // func presentNewTask(withDelegate delegate:VBTaskDetailsVCDelegate)
}

class RootNavigationCoordinator
{
  
    var navigationState: NavigationState = .showingTaskList
    var dependencyRegistry : DependencyRegistry
    var rootVC : UIViewController
    
    init(with rootVC: UIViewController, dependencyRegistry:DependencyRegistry)
    {
        self.rootVC = rootVC
        self.dependencyRegistry = dependencyRegistry
    }
}

extension RootNavigationCoordinator : RootNavigationCoordinatorProtocol
{
    
    func showTaskDetails(task:VBTaskDTO,delegate:VBTaskDetailsVCDelegate) {
        let taskDetailsVC = dependencyRegistry.makeTaskDetailsVC(with: task, delegate: delegate)
        self.navigateTo(taskDetailsVC, usingNavigationMode: .show)
        self.navigationState = .showingTaskDetails
    }
    
}
extension RootNavigationCoordinator : Navigable
{
    func navigateTo(_ destinationVC: UIViewController, usingNavigationMode navigationMode: NavigationMode)
    {
        switch navigationMode
        {
        case .show:
            self.rootVC.navigationController?.pushViewController(destinationVC, animated: true)
        case .present:
            self.rootVC.navigationController?.present(destinationVC, animated: true, completion: nil)

            
        }
    }
    
    func goBack()
    {
        switch self.navigationState
        {
        case .showingTaskList:
            break
        case .showingTaskDetails:
            self.rootVC.navigationController?.popViewController(animated: true)
        case .presentingTaskDetails:
            self.rootVC.navigationController?.dismiss(animated: true, completion: nil)
        }

    }
    
    
}
