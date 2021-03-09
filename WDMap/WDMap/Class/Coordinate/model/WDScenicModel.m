//
//  WDScenicModel.m
//  WDMap
//
//  Created by wbb on 2021/2/25.
//

#import "WDScenicModel.h"

@implementation WDScenicModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"albums" : [WDAlbumsModel class]};
}
@end

@implementation WDAlbumsModel

@end


@implementation WDRelevancePersonModel

@end
@implementation WDRoadModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"childrendata" : [WDRoadChildModel class]};
}
@end
@implementation WDRoadChildModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"jingdiandata" : [WDRoadjingdiandataModel class]};
}
@end
@implementation WDRoadjingdiandataModel

@end
