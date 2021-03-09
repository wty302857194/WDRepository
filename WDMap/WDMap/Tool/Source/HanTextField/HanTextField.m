#import "HanTextField.h"

@interface HanTextField ()<UITextFieldDelegate>

@property(nonatomic, strong) HanHideMenuTextField *textField;
@property(nonatomic, strong) NSMutableArray *labArr;
@property(nonatomic, strong) NSMutableArray *lineArr;
@property(nonatomic, copy) NSString *codeString;

@end

@implementation HanTextField

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
        self.isSecure = NO;
        self.itemNumber = 6;
        self.textColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:16];
    }
    return self;
}
- (void)archive {
    [self.textField becomeFirstResponder];
}
-(void)createSubViews{
    
    self.textField.hidden = NO;
    [self.labArr removeAllObjects];
    
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    CGFloat iw = w/self.itemNumber;

    for (int i = 0; i < self.itemNumber ; i++) {

        UILabel *lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(iw * i, 0, iw, h);
        lab.userInteractionEnabled = YES;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = self.textColor;
        lab.font = self.textFont;
        [lab addTarget:self action:@selector(archive)];

        [self addSubview:lab];
        [self.labArr addObject:lab];
    }
    [self createLineView];
    
}
-(void)createLineView{
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    CGFloat iw = w/self.itemNumber;

    [self.lineArr removeAllObjects];
    for (int i = 0; i < self.itemNumber ; i++) {

        UIView *view = [[UIView alloc] init];
        view.bounds = CGRectMake(0, 0, iw * 0.7, 1);
        view.center = CGPointMake(iw * (0.5 + i) , h - 0.5);
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [self.lineArr addObject:view];
    }
    
}
- (void)textDidChanged:(UITextField *)textField {
    
    if (textField.text.length <= self.itemNumber){
        NSInteger index = textField.text.length - 1;
        if (self.codeString.length < textField.text.length) {
            UILabel *label = self.labArr[index];
            label.text = [textField.text substringFromIndex:index];
            if (self.isSecure) {
                label.text = @"*";
            }
        }else{
            UILabel *label = self.labArr[index + 1];
            label.text = @"";
        }
        if (textField.text.length == self.itemNumber) {
            if (self.block) {
                self.block(textField.text);
            }
        }
    }else{
        textField.text = [textField.text substringToIndex:self.itemNumber];
    }
    
    
    self.codeString = textField.text;
}
#pragma mark - 设置仅可输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
#pragma mark - setter
- (void)setItemNumber:(NSInteger)itemNumber{
    _itemNumber = itemNumber;
    for (UIView *vi in self.subviews) {
        [vi removeFromSuperview];
    }
    self.textField = nil;
    [self createSubViews];
}

- (void)setTextFont:(UIFont *)textFont{
    for (UILabel *lab in self.labArr) {
        lab.font = textFont;
    }
    _textFont = textFont;
}

- (void)setTextColor:(UIColor *)textColor{
    for (UILabel *lab in self.labArr) {
        lab.textColor = textColor;
    }
    _textColor = textColor;
}
-(void)setLineColor:(UIColor *)lineColor{
    for (UIView *view in self.lineArr) {
        view.backgroundColor = lineColor;
    }
    _lineColor = lineColor;
}
#pragma mark - getter
-(UITextField *)textField{
    if (_textField == nil) {
        _textField = [[HanHideMenuTextField alloc] init];
        _textField.frame = self.bounds;
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor clearColor];
        _textField.tintColor = [UIColor clearColor];
        [_textField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:self.textField];
    }
    return _textField;
}

-(NSMutableArray *)labArr{
    if (_labArr == nil) {
        _labArr = [NSMutableArray array];
    }
    return _labArr;
}

-(NSMutableArray *)lineArr{
    if (_lineArr == nil) {
        _lineArr = [NSMutableArray array];
    }
    return _lineArr;
}
@end

@implementation HanHideMenuTextField
#pragma mark - 设置TextField 不可复制 粘贴
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [[UIMenuController sharedMenuController] hideMenu];
    if (action == @selector(copy:)) {
        return NO;
    } else if (action == @selector(selectAll:)) {
        return NO;
    }
    
    return NO;
}
@end
