#import "UIKit/UIKit.h"
#include "RemoteLog.h"

@interface SBMainSwitcherViewController : UIViewController
-(void) _deleteAppLayoutsMatchingBundleIdentifier:(id)arg1;
-(id) recentAppLayouts;
@end

@interface SBDisplayItem: NSObject
-(id)bundleIdentifier;
@end

@interface SBAppLayout: NSObject
-(id)allItems;
@end

@interface SBReusableSnapshotItemContainer : UIView
@end