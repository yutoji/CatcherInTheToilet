import Foundation

enum ShitType: String {
    case normal = "unchi_character"
    case hard   = "unchi_character_yawarakai"
}

extension ShitType {

    var filename: String {
        return rawValue
    }

    func makeStandbyInterval() -> TimeInterval {
        switch self {
        case .normal:
            return 3.0 + TimeInterval.random(in: 0...3)
        case .hard:
            return 2.0 + TimeInterval.random(in: 0...2)
        }
    }

    func scoreGet() -> Int {
        switch self {
        case .normal: return 1
        case .hard:   return 2
        }
    }

    func scoreLose() -> Int {
        return 1
    }
}
