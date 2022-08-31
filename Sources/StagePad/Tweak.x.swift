import Orion
import StagePadC
import UIKit

class SBMainSwitcherViewControllerHook: ClassHook<SBMainSwitcherViewController> {
    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)

        remLog("viewDidAppear")
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