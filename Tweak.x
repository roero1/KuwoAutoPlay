#import <substrate.h>
#import <UIKit/UIKit.h>

static NSString * const targetSongRID = @"275705556";
static BOOL hasTriggered = NO;

@protocol KuwoPlayManager
+ (instancetype)sharedManager;
- (void)playSongWithRID:(NSString *)rid;
@end

%ctor {
    static void (*origImp)(id self, SEL _cmd, UIApplication* app, NSDictionary* opt);
    MSHookMessageEx(
        objc_getClass("KuwoAppDelegate"),
        @selector(application:didFinishLaunchingWithOptions:),
        ^(id self, SEL _cmd, UIApplication* app, NSDictionary* opt) {
            origImp(self, _cmd, app, opt);

            if(hasTriggered) return;
            hasTriggered = YES;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                Class playMgrClass = objc_getClass("KuwoPlayManager");
                if(playMgrClass) {
                    id<KuwoPlayManager> mgr = [playMgrClass sharedManager];
                    if(mgr && [mgr respondsToSelector:@selector(playSongWithRID:)]) {
                        NSLog(@"[KuwoAutoPlay] Try play rid: %@", targetSongRID);
                        [mgr playSongWithRID:targetSongRID];
                    } else {
                        NSLog(@"[KuwoAutoPlay] playSongWithRID: not found");
                    }
                } else {
                    NSLog(@"[KuwoAutoPlay] KuwoPlayManager class not found");
                }
            });
        },
        (IMP *)&origImp
    );
}
