//
//  WDDigitalView.m
//  Education
//
//  Created by wbb on 2021/1/27.
//

#import "WDDigitalView.h"

static const  NSInteger maxWidth = 60;
@interface WDDigitalView()
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *frameArr;

@end
@implementation WDDigitalView
- (instancetype)initWithFrame:(CGRect)frame contentList:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        self.frameArr = [NSMutableArray arrayWithCapacity:0];
        
        [self initUI];
    }
    return self;
}

- (void)initUI {
    
    
    NSInteger width = self.frame.size.width;
    NSInteger height = self.frame.size.height;

    for (int i = 0; i<30; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 元素宽高
        float count = 0;
        // x坐标
        float x = 0;
        // y坐标
        float y = 0;

        
        if (i<self.dataArr.count) {
            count = arc4random()%5 + maxWidth -5;
            [btn addTarget:self action:@selector(touchClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitle:self.dataArr[i][@"name"] forState:UIControlStateNormal];
            
            x = arc4random()%(width/2)+(width/5);
            y = arc4random()%(height/2)+(width/5);
            
            if (i>0) {
                while ([self isContain:CGRectMake(x, y, count, count)]) {
                    x = arc4random()%(width/2)+(width/5);
                    y = arc4random()%(height/2)+(width/5);
                }
            }
        }else {
            btn.userInteractionEnabled = NO;
            count = arc4random()%(maxWidth - 15) +10;
            
            x = arc4random()%(width - (NSInteger)count);
            y = arc4random()%(height - (NSInteger)count);
            
            while ([self isContain:CGRectMake(x, y, count, count)]) {
                x = arc4random()%(width - (NSInteger)count);
                y = arc4random()%(height - (NSInteger)count);
            }
        }
        
        
        if (count>=maxWidth - 5) {
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.shadowColor = [UIColor blackColor].CGColor;
            btn.layer.shadowOpacity = 0.8f;
            btn.layer.shadowRadius = 4.f;
            btn.layer.shadowOffset = CGSizeMake(4,4);
            btn.layer.cornerRadius = count/2.f;

        }else if(count>30) {
            NSInteger num = arc4random()%4;
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"yuan%ld",(long)num]] forState:UIControlStateNormal];
        }else {
            NSInteger num = arc4random()%2+3;
            [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"yuan%ld",(long)num]] forState:UIControlStateNormal];
        }
        
        
        btn.frame = CGRectMake(x, y, count, count);

        [self addSubview:btn];
        
        [self.frameArr addObject:@(btn.frame)];

    }
}
- (BOOL)isContain:(CGRect)currentFrame {

    BOOL isContain = NO;
    for (int i = 0; i<self.frameArr.count; i++) {
        CGRect frame = [self.frameArr[i] CGRectValue];
        if (CGRectIntersectsRect(frame, currentFrame)) {
            isContain = YES;
            break;
        }
    }
    return isContain;
}
- (void)touchClick:(UIButton *)btn {
    [self correctAnchorPointForView:btn];
    
    if (!btn.isSelected) {
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    //        [self setAnchorPoint:CGPointMake(0.5f, 0.5f) forView:self];

        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
    
    
    btn.selected = !btn.selected;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[
            @{
                @"name" : @"李白",
                @"productList" : @[
                    @"作品1",
                    @"作品2",
                    @"作品3"
                ]
            },
            @{
                @"name" : @"杜甫",
                @"productList" : @[
                    @"作品1",
                    @"作品2",
                    @"作品3"
                ]
            },
            @{
                @"name" : @"白居易",
                @"productList" : @[
                    @"作品1",
                    @"作品2",
                    @"作品3"
                ]
            },
        ];
    }
    return _dataArr;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
 
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
 
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

- (void)correctAnchorPointForView:(UIView *)view
{
    CGPoint anchorPoint = CGPointZero;
    CGPoint superviewCenter = view.superview.center;
//   superviewCenter是view的superview 的 center 在view.superview.superview中的坐标。
    CGPoint viewPoint = [view convertPoint:superviewCenter fromView:view.superview.superview];
//   转换坐标，得到superviewCenter 在 view中的坐标
    anchorPoint.x = (viewPoint.x) / view.bounds.size.width;
    anchorPoint.y = (viewPoint.y) / view.bounds.size.height;
 
    [self setAnchorPoint:anchorPoint forView:view];
}
@end
