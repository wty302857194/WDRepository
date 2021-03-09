//
//  WDDynamicModel.h
//  WDMap
//
//  Created by wbb on 2021/2/26.
//

#import "WDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 Json数据
 1.title：标题
 2.img_url：图片
 3.sort_id：排序
 4.content：内容
 5.sub_title：副标题
 其他数据不用理会
 */
@interface WDDynamicModel : WDBaseModel
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * img_url;
@property (nonatomic, copy) NSString * sort_id;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * sub_title;
@property (nonatomic, copy) NSString * add_time;
@property (nonatomic, copy) NSString * click;
@property (nonatomic, copy) NSString * zhaiyao;
@property (nonatomic, copy) NSString * zuozhe;

@property (nonatomic, assign) DynamicType type;


@end

NS_ASSUME_NONNULL_END
