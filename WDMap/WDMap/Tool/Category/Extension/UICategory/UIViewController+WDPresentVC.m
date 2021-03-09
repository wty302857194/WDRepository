//
//  UIViewController+WDPresentVC.m
//  NetClass
//
//  Created by wbb on 2019/10/12.
//  Copyright © 2019 xanway. All rights reserved.
//

#import "UIViewController+WDPresentVC.h"
#import <objc/message.h>

@implementation UIViewController (WDPresentVC)

+ (void)load {
    WD_swizzleMethod([self class], @selector(presentViewController:animated:completion:), @selector(WD_presentViewController:animated:completion:));
}

+ (BOOL)WD_automaticallySetModalPresentationStyle {
    if ([self isKindOfClass:[UIImagePickerController class]] || [self isKindOfClass:[UIAlertController class]] || [self isKindOfClass:[UISearchController class]]) {
        return NO;
    }
    return YES;
}

- (void)WD_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (@available(iOS 13.0, *)) {
        if ([self.class WD_automaticallySetModalPresentationStyle]) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }

    [self WD_presentViewController:viewControllerToPresent animated:flag completion:completion];

}

void WD_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}
@end
