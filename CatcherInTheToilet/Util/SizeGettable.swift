import UIKit

protocol SizeGettable: class {
    var size: CGSize { get }
}

extension SizeGettable {
    var width: CGFloat {
        return size.width
    }
    var height: CGFloat {
        return size.height
    }
}
