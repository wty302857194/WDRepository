//
//  WDBaseView.m
//  Class
//
//  Created by wbb on 2020/3/3.
//  Copyright © 2020 WD. All rights reserved.
//

#import "WDBaseView.h"

@implementation WDBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
+ (instancetype)shareInstance {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
@end
