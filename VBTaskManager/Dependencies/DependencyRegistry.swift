import UIKit
import Swinject
import SwinjectStoryboard

protocol DependencyRegistryProtocol
{
    var container : Container { get }
    
    func makeRootNavigationCoordinator(rootVC:UIViewController) -> RootNavigationCoordinatorProtocol
    typealias TaskCellMaker = (UITableView, IndexPath, VBTaskDTO) -> VBTaskCell
    func makeTaskCell(for tableView:UITableView,at indexPath:IndexPath,for task:VBTaskDTO) -> VBTaskCell
    
    typealias TaskDetailsVCMaker = (VBTaskDTO, VBTaskDetailsVCDelegate) -> VBTaskDetailsVC
    func makeTaskDetailsVC(with task:VBTaskDTO, delegate:VBTaskDetailsVCDelegate) -> VBTaskDetailsVC
    
}

class DependencyRegistry:DependencyRegistryProtocol {
    
    

    var container: Container
    
    init(container: Container) {
        
        Container.loggingFunction = nil
        
        self.container = container
        
        registerDependencies()
        registerPresenters()
        registerViewControllers()
    }
    
    func registerDependencies() {
        
        container.register(RootNavigationCoordinatorProtocol.self) { (r, rootVC:UIViewController) in
        
            return RootNavigationCoordinator(with: rootVC, dependencyRegistry: self)
        }.inObjectScope(.container)
        
        container.register(VBRemoteDataManager.self    ) { _ in VBRemoteDataManager()  }.inObjectScope(.container)
        container.register(VBLocalDataManager.self){_ in VBLocalDataManager()}.inObjectScope(.container)
        container.register(VBDataManager.self){ r in
            VBDataManager(remoteDataManager: self.container.resolve(VBRemoteDataManager.self)!, localDataManager: self.container.resolve(VBLocalDataManager.self)!)
        }.inObjectScope(.container)

    }
    
    func registerPresenters() {
        container.register(VBTasksPresenter.self){r in VBTasksPresenter(dataManager: r.resolve(VBDataManager.self)!)}
        container.register(VBTaskCellPresenter.self){ (r, task: VBTaskDTO) in VBTaskCellPresenter(task: task)}
        container.register(VBTaskDetailsPresenter.self){ (r, task:VBTaskDTO) in VBTaskDetailsPresenter(task: task,dataManager: r.resolve(VBDataManager.self)!)}
    }
    
    func registerViewControllers() {
        
        container.register(VBTaskDetailsVC.self) {(r, task:VBTaskDTO, delegate:VBTaskDetailsVCDelegate) in
            let presenter = r.resolve(VBTaskDetailsPresenter.self,argument: task)!
            
            let storyboard = UIStoryboard(name: "VBTaskDetailsVC", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! VBTaskDetailsVC
            vc.configure(presenter: presenter, delegate: delegate)
            return vc
            
        }

    }

    //MARK: - Maker Methods
    
    func makeRootNavigationCoordinator(rootVC: UIViewController) -> RootNavigationCoordinatorProtocol
    {
        let rootNavigationCoordinator = container.resolve(RootNavigationCoordinatorProtocol.self, argument: rootVC)!
        return rootNavigationCoordinator
    }
    
    typealias TaskCellMaker = (UITableView, IndexPath, VBTaskDTO) -> VBTaskCell
    func makeTaskCell(for tableView:UITableView,at indexPath:IndexPath,for task:VBTaskDTO) -> VBTaskCell
    {
        let presenter = container.resolve(VBTaskCellPresenter.self, argument: task)!
        let cell = VBTaskCell.dequeueCell(from: tableView, for: indexPath, with: presenter)
        return cell
    }
    
    typealias TaskDetailsVCMaker = (VBTaskDTO, VBTaskDetailsVCDelegate) -> VBTaskDetailsVC
    func makeTaskDetailsVC(with task:VBTaskDTO, delegate:VBTaskDetailsVCDelegate) -> VBTaskDetailsVC
    {

        return container.resolve(VBTaskDetailsVC.self, arguments: task, delegate)!
    }

}
