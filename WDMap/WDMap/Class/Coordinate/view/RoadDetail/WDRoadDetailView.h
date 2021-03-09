//
//  WDRoadDetailView.h
//  WDMap
//
//  Created by wbb on 2021/2/16.
//

#import "WDBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LocationBlock)(CGPoint point);
@class WDRoadjingdiandataModel;
@interface WDRoadDetailView : WDBaseView
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *clockNumLab;
@property (weak, nonatomic) IBOutlet UILabel *locationNumLab;
@property (weak, nonatomic) IBOutlet UIView *contentBackView;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@property (nonatomic, copy) LocationBlock  locationBlock;

- (void)GetxianlutoidRequestData:(NSString *)ID;
@end

NS_ASSUME_NONNULL_END
