#import "UIKit/UIKit.h"
#include "RemoteLog.h"

@interface SBAppSwitcherSnapshotCacheEntry : NSObject
@end

@interface SBAppSwitcherSnapshotImageCache : NSObject
@end

@interface SBDeckSwitcherViewController : UIViewController
- (id)iconForDisplayItem:(id)arg1;
@end

@interface SBMainSwitcherViewController : UIViewController
- (void)_deleteAppLayoutsMatchingBundleIdentifier:(id)arg1;
- (id)recentAppLayouts;
- (id)contentViewController;
@end

@interface SBDisplayItem: NSObject
- (id)bundleIdentifier;
@end

@interface SBAppLayout: NSObject
- (id)allItems;
@end

@interface SBReusableSnapshotItemContainer : UIView
@end

@interface SBAppSwitcherScrollView : UIView
@end