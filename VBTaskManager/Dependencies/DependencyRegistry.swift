import UIKit
import Swinject
import SwinjectStoryboard

protocol DependencyRegistryProtocol
{
    var container : Container { get }
    
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
    
//    typealias SpyCellMaker = (UITableView, IndexPath, SpyDTO) -> SpyCell
//    func makeSpyCell(for tableView: UITableView, at indexPath: IndexPath, spy: SpyDTO) -> SpyCell {
//        let presenter = container.resolve(SpyCellPresenter.self, argument: spy)!
//        let cell = SpyCell.dequeue(from: tableView, for: indexPath, with: presenter)
//        return cell
//    }
//    
//    typealias DetailViewControllerMaker = (SpyDTO) -> DetailViewController
//    func makeDetailViewController(with spy: SpyDTO) -> DetailViewController {
//        return container.resolve(DetailViewController.self, argument: spy)!
//    }
//
//    typealias SecretDetailsViewControllerMaker = (SpyDTO, SecretDetailsDelegate)  -> SecretDetailsViewController
//    func makeSecretDetailsViewController(with spy: SpyDTO, delegate: SecretDetailsDelegate) -> SecretDetailsViewController {
//        return container.resolve(SecretDetailsViewController.self, arguments: spy, delegate)!
//    }
}
