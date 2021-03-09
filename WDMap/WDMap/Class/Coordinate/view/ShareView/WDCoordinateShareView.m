//
//  WDCoordinateShareView.m
//  WDMap
//
//  Created by wbb on 2021/2/17.
//

#import "WDCoordinateShareView.h"
@interface WDCoordinateShareView()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
@implementation WDCoordinateShareView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.backView addTarget:self action:@selector(click)];

}
- (void)layoutSubviews {
    [super layoutSubviews];
    [WDGlobal addCorners:self.contentView];

}


- (void)click {
    self.hidden = YES;
    
}
- (IBAction)touchClick:(UIButton *)sender {
    
    
    if (self.touchHiddenBlock) {
        self.touchHiddenBlock(sender.tag - 10);
    }
}

- (IBAction)cancelClick:(id)sender {
    [self click];
}

@end
