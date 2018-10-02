enum PlayEvent {
    case gotShit(ShitType)
    case lostShit(ShitType)
}

extension PlayEvent {
    static func ==(lhs: PlayEvent, rhs: PlayEvent) -> Bool {
        switch (lhs, rhs) {
        case let (.gotShit(left), .gotShit(rite)):
            return left == rite
        case let (.lostShit(left), .lostShit(rite)):
            return left == rite
        default:
            return false
        }
    }
}
