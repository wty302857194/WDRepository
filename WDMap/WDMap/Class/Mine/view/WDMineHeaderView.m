//
//  WDMineHeaderView.m
//  WDMap
//
//  Created by wbb on 2021/2/7.
//

#import "WDMineHeaderView.h"
@interface WDMineHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *cornerView;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@end
@implementation WDMineHeaderView

+ (instancetype)scenicView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)drawRect:(CGRect)rect {
    self.cornerView.layer.cornerRadius = self.cornerView.height/2.f;
    self.userImageView.layer.cornerRadius = self.userImageView.height/2.f;
    [self addCorners];
}

- (void)addCorners {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(30, 30)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.path = path.CGPath;
    self.backView.layer.mask = layer;
}
@end
