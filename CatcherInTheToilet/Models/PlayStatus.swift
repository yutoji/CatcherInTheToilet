import Foundation

protocol PlayStatusProtocol {
    var score: Int { get }
    func appendDelegate(delegate: PlayStatusDelegate)
}

protocol PlayStatusDelegate {
    func onScoreUpdated()
    func onEventOccured(event: PlayEvent)
}

class PlayStatus: PlayStatusProtocol {
    let MIN_SCORE: Int = 0
    private var delegates: DelegateContainer<PlayStatusDelegate> = DelegateContainer()
    var score: Int {
        return _score
    }

    private var _score: Int = 0

    func appendDelegate(delegate: PlayStatusDelegate) {
        delegates.append(delegate: delegate)
    }

    func onShitGot(type: ShitType) {
        let scoreGet = type.scoreGet()
        _updateScore(diff: scoreGet)
        _fireEvent(event: PlayEvent.gotShit(type) )
    }

    func onShitLost(type: ShitType) {
        let scoreLoss = type.scoreLose()
        _updateScore(diff: -scoreLoss)
        _fireEvent(event: PlayEvent.lostShit(type) )
    }

    private func _updateScore(diff: Int) {
        let newScoreRaw = _score + diff
        let newScore = max(newScoreRaw, MIN_SCORE)
        if newScore == _score {
            return
        }
        _score = newScore
        delegates.forEach() { delegate in
            delegate.onScoreUpdated()
        }
    }

    private func _fireEvent(event:PlayEvent) {
        delegates.forEach() { delegate in
            delegate.onEventOccured(event: event)
        }
    }
}
