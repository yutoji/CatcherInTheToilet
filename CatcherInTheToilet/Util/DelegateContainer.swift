import Foundation

class DelegateContainer<DelegateType> {
    private var delegates: [WeakWrapper<DelegateType>] = []

    func append(delegate: DelegateType) {
        delegates.append(WeakWrapper(delegate))
        cleanUp()
    }

    func forEach(_ callback: (DelegateType) -> Void) {
        cleanUp()
        for wrapper in delegates {
            if let delegate = wrapper.object {
                callback(delegate)
            }
        }
    }

    func count() -> Int {
        cleanUp()
        return delegates.count
    }

    private func cleanUp() {
        delegates = delegates.filter({ $0.object != nil })
    }

}
