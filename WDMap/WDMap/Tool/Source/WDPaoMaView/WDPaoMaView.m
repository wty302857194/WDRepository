//
//  WDPaoMaView.m
//  WDMap
//
//  Created by wbb on 2021/2/3.
//

#import "WDPaoMaView.h"

static const NSInteger lab_height = 30;
@interface WDPaoMaView()
@property (nonatomic, copy) NSArray * listArr;
@property (nonatomic, strong) UIView * leftView;
@property (nonatomic, strong) UIView * rightView;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, assign) CGFloat view_width;
@property (nonatomic, assign) CGFloat left_offset;
@end
@implementation WDPaoMaView

- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
}
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
//注意: 创建对象用[[xxx alloc]init]方法和[[xxx alloc]initWithFrame]:方法都会调用initWithFrame:
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}
- (instancetype)initWithList:(NSArray *)list {
    self = [super init];
    if (self) {
        self.listArr = list;
        self.left_offset = 0;
        [self initTimer];
        [self setUp];
    }
    return self;
}
+ (instancetype)paoMaViewWithList:(NSArray *)list {
    return [[self alloc] initWithList:list];
}
- (void)initTimer {
    kWEAK_SELF;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC, 0.02 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        weakSelf.left_offset--;
        
        if (weakSelf.left_offset + weakSelf.view_width <= 0) {
            UIView *view = weakSelf.leftView;
            weakSelf.leftView = weakSelf.rightView;
            weakSelf.rightView = view;
            weakSelf.left_offset = 0;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateLayout];
        });
    });
    dispatch_resume(timer);
    self.timer = timer;
}
- (void)setUp {
    
    UIView *rightView = [[UIView alloc] init];
    [self addSubview:rightView];
    self.rightView = rightView;
    
    UIView *leftView = [[UIView alloc] init];
    [self addSubview:leftView];
    self.leftView = leftView;
    
    UILabel *selectLeftLab = nil;
    UILabel *selectRightLab = nil;
    float view_width = 10.f;
    
    for (int i=0; i<self.listArr.count; i++) {
        UILabel *leftLab = [[UILabel alloc] init];
        leftLab.text = self.listArr[i];
        leftLab.textAlignment = NSTextAlignmentCenter;
        leftLab.font = [UIFont systemFontOfSize:12];
        leftLab.textColor = [UIColor lightGrayColor];
        [leftLab setCornerRadius:lab_height/2.f];
        leftLab.layer.borderWidth = 1;
        leftLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [leftView addSubview:leftLab];
        
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = self.listArr[i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = [UIColor lightGrayColor];
        [lab setCornerRadius:lab_height/2.f];
        lab.layer.borderWidth = 1;
        lab.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [rightView addSubview:lab];

        
        float labWidth = [WDGlobal widthForText:self.listArr[i] textFont:12 standardHeight:lab_height];
        if (labWidth < lab_height) {
            labWidth = lab_height;
        }
        view_width = view_width + (10 + labWidth+10);
        
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.offset(10);
            }else {
                make.left.equalTo(selectLeftLab.mas_right).offset(10);
            }
            make.centerY.offset(0);
            make.width.offset(labWidth + 10);
            make.height.offset(lab_height);
        }];
        selectLeftLab = leftLab;
        
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.offset(10);
            }else {
                make.left.equalTo(selectRightLab.mas_right).offset(10);
            }
            make.centerY.offset(0);
            make.width.offset(labWidth + 10);
            make.height.offset(lab_height);
        }];
        selectRightLab = lab;

    }
    
    if(view_width < kSCREEN_WIDTH) {
        self.rightView.hidden = YES;
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    self.view_width = view_width;
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.offset(0);
        make.width.offset(view_width);
    }];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(view_width);
        make.width.offset(view_width);
    }];
}

- (void)updateLayout {
    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(self.left_offset);
        make.width.offset(self.view_width);
    }];
    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(self.left_offset+self.view_width);
        make.width.offset(self.view_width);

    }];
}
@end
