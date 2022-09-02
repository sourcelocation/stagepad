import Orion
import StagePadC
import UIKit

class SBMainSwitcherViewControllerHook: ClassHook<SBMainSwitcherViewController> {
    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)
        /* For native
        target.transform = CGAffineTransform(a: 0, b: 1, c: 1, d: 0, tx: 1, ty: 1)
        target.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
 */
    }

    // orion:new
    func getAppLayouts() -> [SBAppLayout] {
        return target.recentAppLayouts() as? [SBAppLayout] ?? []
    }

    // orion:new
    func closeAllApps() {
        for appLayout in getAppLayouts() {
            guard let displayItems = appLayout.allItems() as? [SBDisplayItem], 
                    displayItems.count > 0 else { continue }
            let item = displayItems[0]
            guard let bundleId = item.bundleIdentifier() as? String else { continue }
            closeApp(bundleId)
        }
    }
    
    // orion:new
    func closeApp(_ bundleID: String) {
        target._deleteAppLayouts(matchingBundleIdentifier:bundleID)
    }
}