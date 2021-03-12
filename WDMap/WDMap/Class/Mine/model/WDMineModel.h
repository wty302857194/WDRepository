//

//  WDMineModel.h

//  WDMap

//

//  Created by wbb on 2021/3/8.

//

#import "WDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDMineModel : WDBaseModel

@end

@interface WDMineXunzhangModel : WDBaseModel

@property (nonatomic, copy) NSString * xunzhang;
@property (nonatomic, copy) NSString * appxunzhang;
@end

NS_ASSUME_NONNULL_END
