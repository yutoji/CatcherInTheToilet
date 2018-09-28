class EvenRandomLoopIterator<Element> {
    private let list: [Element]
    private var waitingList: [Element]

    init(_ list: [Element]) {
        self.list = list
        self.waitingList = list.shuffled()
    }

    func next() -> Element? {
        resetIfNeeded()
        let result = waitingList.popLast()
        return result
    }

    private func resetIfNeeded() {
        if waitingList.count == 0 {
            waitingList = list.shuffled()
        }
    }
}
