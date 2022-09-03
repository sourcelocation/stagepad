import Orion
import StagePadC
import UIKit
import SwiftUI

// fileprivate var switcherView: View?

class SBMainSwitcherViewControllerHook: ClassHook<SBMainSwitcherViewController> {
    

    func viewDidLoad() {
        orig.viewDidLoad()

        let switcherView = AppSwitcherView(apps: []).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let hostingVC = UIHostingController(rootView: switcherView)
        let switcherUIView = hostingVC.view!
        target.view.addSubview(switcherUIView)
        switcherUIView.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
    }

    func viewDidAppear(_ animated: Bool) {
        orig.viewDidAppear(animated)

    }

    // orion:new
    func getApps() -> [AppSwitcherApp] {
        let contentVC = target.contentViewController() as! SBDeckSwitcherViewController
        let snapshotCache = Ivars<SBAppSwitcherSnapshotImageCache>(contentVC)._snapshotCache
        let cachedSnapshots = Ivars<NSMutableDictionary>(snapshotCache)._cachedSnapshots
        guard let snapshots = cachedSnapshots.allValues as? [SBAppSwitcherSnapshotCacheEntry] else { return []}

        var res: [AppSwitcherApp] = []
        for s in snapshots {
            let snapshotImage = Ivars<UIImage>(s)._snapshotImage
            let displayItem = Ivars<SBDisplayItem>(s)._displayItem
            guard let icon = contentVC.icon(forDisplayItem: displayItem) as? UIImage else { continue }

            res.append(AppSwitcherApp(previewImage: snapshotImage, title: "App Name", icon: icon))
        }
        remLog(res)
        return []
    }

    // orion:new
    func getAppLayouts() -> [SBAppLayout] {
        return target.recentAppLayouts() as? [SBAppLayout] ?? []
    }

    // orion:new
    func getDisplayItems() -> [SBDisplayItem] {
        return getAppLayouts().map { ($0.allItems() as! [SBDisplayItem])[0] }
    }
    // orion:new
    func closeAllApps() {
        for item in getDisplayItems() {
            guard let bundleId = item.bundleIdentifier() as? String else { continue }
            closeApp(bundleId)
        }
    }
    
    // orion:new
    func closeApp(_ bundleID: String) {
        target._deleteAppLayouts(matchingBundleIdentifier:bundleID)
    }
}
