//
//  WDMusicAlbumModel.m
//  WDMap
//
//  Created by wbb on 2021/2/25.
//

#import "WDMusicModel.h"
@implementation WDMusicModel

@end


@implementation WDMusicAlbumModel

@end

@implementation WDHotMusicModel

@end

@implementation WDGetyinyueModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"playMusicList":@"data"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"playMusicList" : [WDPlayMusicListModel class]};
}
@end

@implementation WDPlayMusicListModel

@end
