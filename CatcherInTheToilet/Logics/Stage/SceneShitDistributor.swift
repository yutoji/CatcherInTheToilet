import UIKit

protocol SceneShitDistributor {
    var delegate: SceneShitDistributorDelegate? { get set }
    func start()
    func stop()
}

protocol SceneShitDistributorDelegate {
    func onDistributed(newShit: ShitNode)
}
