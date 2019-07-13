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


                let presenter = r.resolve(VBTasksPresenter.self)!

                let coordinator = dependencyRegistry.makeRootNavigationCoordinator(rootVC: vc)
                //NOTE: We don't have access to the constructor for this VC so we are using method injection
                vc.configure(with: presenter,navigationCoordinator: coordinator, taskCellMaker: dependencyRegistry.makeTaskCell)

            }
        }
        
        
        
        main()
    }
}
