import UIKit
import Swinject
import SwinjectStoryboard

// This enables injection of the initial view controller from the app's main
//   storyboard project settings. So, this is the starting point of the
//   dependency tree.
extension SwinjectStoryboard {
    public class func setup() {
        if AppDelegate.dependencyRegistry == nil {
            AppDelegate.dependencyRegistry = DependencyRegistry(container: defaultContainer)
        }
        
        let dependencyRegistry: DependencyRegistry = AppDelegate.dependencyRegistry
        
        func main() {
            dependencyRegistry.container.storyboardInitCompleted(VBTasksTVC.self) { r, vc in


                if ProcessInfo.processInfo.arguments.contains("UITests")
                {
                    let presenter = r.resolve(VBTasksPresenterUITestMock.self)
                    //NOTE: We don't have access to the constructor for this VC so we are using method injection
                    vc.configure(with: presenter!, taskDetailsVCMaker: dependencyRegistry.makeTaskDetailsVC, taskCellMaker: dependencyRegistry.makeTaskCell)
                    
                }else
                {
                    let presenter = r.resolve(VBTasksPresenter.self)!
                    //NOTE: We don't have access to the constructor for this VC so we are using method injection
                    vc.configure(with: presenter, taskDetailsVCMaker: dependencyRegistry.makeTaskDetailsVC, taskCellMaker: dependencyRegistry.makeTaskCell)
                }

               

            }
        }
        
        
        
        main()
    }
}
