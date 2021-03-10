//
//  WDDigitModel.h
//  WDMap
//
//  Created by wbb on 2021/3/10.
//

#import "WDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDDigitModel : WDBaseModel
@property (nonatomic, copy) NSString * color;
@property (nonatomic, copy) NSString * sort_id;
@property (nonatomic, copy) NSString * parent_id;

@property (nonatomic, assign) BOOL isSelect;
@end

/*
 Json数据
 1.ID：数据ID
 2.category_id：年代ID
 3.sort_id:排序
 4.xingming：姓名
 5.touxiang：头像
 其他数据不用理会
 */
@interface WDPoetModel : WDBaseModel
@property (nonatomic, copy) NSString * category_id;
@property (nonatomic, copy) NSString * sort_id;
@property (nonatomic, copy) NSString * xingming;
@property (nonatomic, copy) NSString * touxiang;

@end
NS_ASSUME_NONNULL_END
