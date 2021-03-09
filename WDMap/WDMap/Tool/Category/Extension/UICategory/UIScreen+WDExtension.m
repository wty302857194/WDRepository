//
//  UIScreen+WDExtension.m
//  NetClass
//
//  Created by wbb on 15/12/8.
//  Copyright © 2015年 WD. All rights reserved.
//

#import "UIScreen+WDExtension.h"

@implementation UIScreen (Extension)

+ (CGSize)WD_screenSize {
    return [UIScreen mainScreen].bounds.size;
}

+ (BOOL)WD_isRetina {
    return [UIScreen WD_scale] >= 2;
}

+ (CGFloat)WD_scale {
    return [UIScreen mainScreen].scale;
}

@end
