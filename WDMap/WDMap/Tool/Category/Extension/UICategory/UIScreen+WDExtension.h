//
//  UIScreen+WDExtension.h
//  NetClass
//
//  Created by wbb on 15/12/8.
//  Copyright © 2015年 WD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (Extension)

+ (CGSize)WD_screenSize;
+ (BOOL)WD_isRetina;
+ (CGFloat)WD_scale;

@end
