//
//  AppDelegate.h
//  WDMap
//
//  Created by wbb on 2021/1/29.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isRootLogin;

- (void)setRootVC;
- (void)rootLoginVC;
- (void)rootTabBarVC:(NSInteger)index;
- (void)rootHomeVC;
@end

