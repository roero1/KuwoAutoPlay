#import <substrate.h>
#import <UIKit/UIKit.h>

static NSString * const targetSongRID = @"275705556";
static BOOL hasTriggered = NO;

@protocol KuwoPlayManager
+ (instancetype)sharedManager;
- (void)playSongWithRID:(NSString *)rid;
@end

%ctor {
    MSHookMessageEx(
        objc_getClass("KuwoAppDelegate"),
        @selector(application:didFinishLaunchingWithOptions:),
        ^(id self, SEL _cmd, UIApplication* app, NSDictionary* opt) {
            
            // ========== MSHookMessageEx 写法：手动调用原始实现 ==========
            // 定义一个函数指针保存原方法
            static void (*origImp)(id self, SEL _cmd, UIApplication* app, NSDictionary* opt);
            if (origImp) {
                origImp(self, _cmd, app, opt); // ✅ 这才是 MSHook 里面调用原方法，不是 %orig
            }

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
        (IMP *)&origImp // ⭐ 重点！把原始实现存进 origImp
    );
}
