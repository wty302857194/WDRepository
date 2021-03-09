//
//  UIDevice+WDDevice.m
//  NetClass
//
//  Created by wbb on 2020/3/7.
//  Copyright © 2020 WD. All rights reserved.
//

#import "UIDevice+WDDevice.h"


@implementation UIDevice (WDDevice)
+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationUnknown) forKey:@"orientation"];
    [[UIDevice currentDevice] setValue:@(interfaceOrientation) forKey:@"orientation"];
}
@end
