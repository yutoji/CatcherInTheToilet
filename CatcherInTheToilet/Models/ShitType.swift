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
        case .normal: return 3
        case .hard:   return 5
        }
    }

    func scoreLose() -> Int {
        return 1
    }

    var theName: String {
        switch self {
        case .normal:
            return "Mr. Shit"
        case .hard:
            return "Hard Shit"
        }
    }
}
