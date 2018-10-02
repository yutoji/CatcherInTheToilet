import Foundation
import UIKit

/// The Logic of Comment Streaming like Niconico
class CommentStreamLogic {

    var screenWidth: CGFloat
    var timeSpan: CGFloat

    init(screenWidth: CGFloat, streamTimeSpan: TimeInterval) {
        self.screenWidth = screenWidth
        self.timeSpan = CGFloat(streamTimeSpan) // time to stream comment
    }

    // origin-point: screen.right
    // origin-time : 0
    // first-right-line => preceding item's right-side-line:
    //   from: item.width, 0
    //     to: -screen.width, timeSpan
    // second-left-line => succeeding item's left-side-line:
    //   from: 0, timeDiff
    //     to: -screen.width-label.width, timeDiff + timeSpan
    func willCollide(preceding pre: CommentStreamLogicItem, succeeding suc: CommentStreamLogicItem) -> Bool {
        assert(pre.startedAt <= suc.startedAt, "order!")
        let timeDiff = CGFloat(suc.startedAt.timeIntervalSince1970 - pre.startedAt.timeIntervalSince1970)
        let preRightSegment = (
            from: CGPoint(x: pre.width,
                          y: 0),
            to  : CGPoint(x: -screenWidth,
                          y: timeSpan)
        )
        let sucLeftSegment = (
            from: CGPoint(x: 0,
                          y: timeDiff),
            to  : CGPoint(x: -screenWidth - suc.width,
                          y: timeDiff + timeSpan)
        )
        let preRightYofZeroX = point(onWhichSegment: preRightSegment, ofX: 0).y
        let sucLeftYofScreenLeftX = point(onWhichSegment: sucLeftSegment, ofX: -screenWidth).y
        let noCollideScreenRightSide   = preRightYofZeroX <= sucLeftSegment.from.y  // including border values
        let noCollideScreenLeftSideInt = preRightSegment.to.y <= sucLeftYofScreenLeftX // including border values
        let noCollide = noCollideScreenRightSide && noCollideScreenLeftSideInt
        return !noCollide
    }

    private func point(onWhichSegment segment: (from: CGPoint, to: CGPoint), ofX x: CGFloat) -> CGPoint {
        return CommentStreamLogic.point(onWhichSegment: segment, ofX: x)
    }
    
    class func point(onWhichSegment segment: (from: CGPoint, to: CGPoint), ofX x: CGFloat) -> CGPoint {
        let xRatio = (x - segment.from.x) / (segment.to.x - segment.from.x)
        let y = (segment.to.y - segment.from.y) * xRatio + segment.from.y
        return CGPoint(x: x, y: y)
    }

}

protocol CommentStreamLogicItem {
    var width: CGFloat { get }
    var startedAt: Date { get }
}

class CommentStreamLogicItemImpl: CommentStreamLogicItem {
    var width: CGFloat
    var startedAt: Date
    init(width: CGFloat, startedAt: Date) {
        self.width = width
        self.startedAt = startedAt
    }
}
