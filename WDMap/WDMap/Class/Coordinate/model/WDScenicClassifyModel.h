//
//  WDScenicClassifyModel.h
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import "WDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
     color = "#f1a782";
     id = 53;
     "img_url" = "https://wxdtoss.oss-cn-beijing.aliyuncs.com/upload/202010/17/202010170041076153.png";
     "parent_id" = 0;
     scale = 2;
     title = "\U6545\U5c45/\U7eaa\U5ff5\U9986";
 }
 */
@interface WDScenicClassifyModel : WDBaseModel
@property (nonatomic, copy) NSString * color;
@property (nonatomic, copy) NSString * appweixuanimg_url;
@property (nonatomic, copy) NSString * appxuanzhongimg_url;
@property (nonatomic, copy) NSString * parent_id;
@property (nonatomic, copy) NSString * scale;
@property (nonatomic, copy) NSArray * childrendata;
@end

NS_ASSUME_NONNULL_END
