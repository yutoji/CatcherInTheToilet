import Foundation

protocol GameTimerProtocol: class {
    var interval: TimeInterval { get set }
    var repeats: Bool { get }
    var completion: (() -> Void)? { get set }

    var isRunning: Bool { get }
    func start()
    func stop()
}

/// Usage:
/// ```
///   let timer = GameTimer(repeats: true)
///   timer.interval = 3.0
///   timer.completion = { [weak self] in
///       self?.doSomething()
///   }
///   timer.start()
/// ```
///
/// Use Caution:
///   If you lost the reference to this object,
///   timer will be automatically stopped by deinit()
class GameTimer: GameTimerProtocol {

    var interval: TimeInterval = .greatestFiniteMagnitude
    var repeats: Bool
    var completion: (() -> Void)?
    private var timer: Timer?

    private var shouldStop: Bool = false

    init(repeats: Bool) {
        self.repeats = repeats
    }

    convenience init(interval: TimeInterval, repeats: Bool) {
        self.init(repeats: repeats)
        self.interval = interval
    }

    var isRunning: Bool {
        return timer?.isValid ?? false
    }

    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats) {
            [weak self] (timer) in
            self?._onTick()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func _onTick() {
        completion?()
        if !repeats {
            timer = nil
        }
    }

    deinit {
        timer?.invalidate()
    }

}

class StubGameTimer: GameTimerProtocol {
    var interval: TimeInterval = .greatestFiniteMagnitude
    var repeats: Bool = false
    var isRunning: Bool = false
    var completion: (() -> Void)?

    var calledFuncNames: [String] = []

    func start() {
        isRunning = true
        calledFuncNames.append("start")
    }

    func stop() {
        isRunning = false
        calledFuncNames.append("stop")
    }
}
