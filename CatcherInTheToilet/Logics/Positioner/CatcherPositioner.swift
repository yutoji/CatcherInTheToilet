import UIKit

protocol CatcherPositioner {
    var delegate: CatcherPositionerDelegate? { get set }
    var nextPosition: CGPoint { get }
}

protocol CatcherPositionerDelegate: class {
   func onCatcherPositionUpdated()
}
