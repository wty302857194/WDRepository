//
//  AppDelegate.h
//  WDMap
//
//  Created by wbb on 2021/1/29.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isRootTabBarVC;

- (void)setRootVC;
- (void)rootLoginVC;
- (void)rootTabBarVC:(NSInteger)index;
- (void)rootHomeVC;
@end

