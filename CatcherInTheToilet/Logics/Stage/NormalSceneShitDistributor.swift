import Foundation

/// Use Caution:
///   If you lost the reference to the instance of this class,
///   timer will be automatically stopped in deinit().
class NormalSceneShitDistributor: SceneShitDistributor {
    var delegate: SceneShitDistributorDelegate?

    let INTERVAL: TimeInterval = 3
    private let positionGainable: ShitStartPositionGainable
    private let timer: GameTimerProtocol

    init(positionGainable: ShitStartPositionGainable, timer: GameTimerProtocol) {
        self.positionGainable = positionGainable
        self.timer = timer
        timer.interval = INTERVAL
        timer.completion = { [weak self] in
            self?._onTick()
        }
    }

    func start() {
        timer.start()
    }

    func stop() {
        timer.stop()
    }

    private func _onTick() {
        let shit = ShitNode(type: .normal) // TODO: select type
        let startPosition = positionGainable.gain(ofShit: shit)
        shit.position = startPosition
        delegate?.onDistributed(newShit: shit)
    }

    deinit {
        if timer.isRunning {
            timer.stop()
        }
    }
}
