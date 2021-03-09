//
//  HanTextField.h
//  WDMap
//
//  Created by wbb on 2021/1/30.
//

#import "WDBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef  void(^HanTextFieldBlock)(NSString * _Nullable codeString);

@interface HanTextField : WDBaseView
@property(nonatomic, assign)NSInteger itemNumber;
@property(nonatomic, assign)BOOL isSecure;
@property(nonatomic, strong)UIFont *textFont;
@property(nonatomic, strong)UIColor *textColor;
@property(nonatomic, strong)UIColor *lineColor;
//输入指定位数字符后的回调
@property(nonatomic, copy)HanTextFieldBlock block;
@end

@interface HanHideMenuTextField:UITextField

@end
NS_ASSUME_NONNULL_END
