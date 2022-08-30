import Orion
import StagePadC
import UIKit

class SBAppSwitcherScrollViewHook: ClassHook<SBAppSwitcherScrollView> {
    func didMoveToWindow() {
        target.transform = .init(rotationAngle: -.pi / 2)
    }
}