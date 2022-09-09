import Orion
import StagePadC
import UIKit
import SwiftUI

fileprivate var switcherUIView: UIView?

class SBAppSwitcherScrollViewHook: ClassHook<SBAppSwitcherScrollView> {
    func setScrollEnabled(_ enabled: Bool) {
        orig.setScrollEnabled(enabled)

        remLog("enabled", enabled)
        if !enabled {
			UIView.animate(withDuration: 0.2, animations: {
				switcherUIView?.alpha = 0
			})
		} else {
			UIView.animate(withDuration: 0.2, animations: {
				switcherUIView?.alpha = 1
			})
		}

    }
}

class SBReusableSnapshotItemContainerHook: ClassHook<SBReusableSnapshotItemContainer> {
    func didMoveToSuperview() {
        orig.didMoveToSuperview()
        // target.removeFromSuperview()
    }
}

class SBMainSwitcherViewControllerHook: ClassHook<SBMainSwitcherViewController> {
    func viewWillAppear(_ animated: Bool) {
        orig.viewWillAppear(animated)

        let contentVC = self.target.contentViewController() as! SBDeckSwitcherViewController
        
        // let contentView = contentVC.contentView() as! UIView
        // contentView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            let apps = self.getApps()
            if switcherUIView == nil {
                switcherView = AppSwitcherView(apps: apps)
                let hostingVC = UIHostingController(rootView: switcherView)
                self.target.view.addSubview(hostingVC.view!)
                hostingVC.view.backgroundColor = .clear
                switcherUIView = hostingVC.view!
                switcherUIView?.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                switcherUIView?.alpha = 0
                UIView.animate(withDuration: 0.2, animations: {
                    switcherUIView?.alpha = 1
                })
             }
             remLog("newapps", apps)
            switcherView?.apps = apps

        })
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
            // remLog(snapshotImage, displayItem, contentVC.icon(forDisplayItem: displayItem) as? UIImage)
            // guard let icon = contentVC.icon(forDisplayItem: displayItem) as? UIImage else { continue }

            res.append(AppSwitcherApp(previewImage: snapshotImage, title: "App Name", icon: UIImage(systemName: "applelogo")!, bundleID: displayItem.bundleIdentifier() as! String))
        }

        // sort
        let recentsBundleIDs = getDisplayItems().map { $0.bundleIdentifier() as! String }
        return recentsBundleIDs.compactMap { recentBundleID in res.first { app in app.bundleID == recentBundleID}}
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
