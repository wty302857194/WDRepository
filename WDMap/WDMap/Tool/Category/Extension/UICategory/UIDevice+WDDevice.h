//
//  UIDevice+WDDevice.h
//  NetClass
//
//  Created by wbb on 2020/3/7.
//  Copyright © 2020 WD. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (WDDevice)

/**
 * @interfaceOrientation 输入要强制转屏的方向
 */
+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

NS_ASSUME_NONNULL_END
