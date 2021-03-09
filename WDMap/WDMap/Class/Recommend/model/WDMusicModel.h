//
//  WDMusicModel.h
//  WDMap
//
//  Created by wbb on 2021/2/25.
//

#import "WDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDMusicModel : WDBaseModel
@property (nonatomic, copy) NSString * img_url;
@property (nonatomic, copy) NSString * title;
@end

/// 声音盒子专辑
/*
 Json数据
 1.ID：数据ID
 2.title：专辑名称
 3.sort_id:排序
 4.parent_id:父级ID （父级ID等于0的表示一级）
 5.img_url：图标
 6.is_top：0表示不推荐 1表示推荐
 7.is_jingxuan： 0表示不精选 1表示精选
 8.bofangliang：播放量
 9.content：简介
 其他数据不用理会
 */

@interface WDMusicAlbumModel : WDMusicModel
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * sort_id;
@property (nonatomic, copy) NSString * parent_id;
@property (nonatomic, copy) NSString * is_top;
@property (nonatomic, copy) NSString * is_jingxuan;
@property (nonatomic, copy) NSString * bofangliang;
@property (nonatomic, copy) NSString * content;

@end


/*
 音乐 热门单曲：
 1.zhuanji：专辑名
 2.title：单曲名称
 3.img_url：封面图片

 {
id = 57;
"img_url" = "";
title = "Words on Water";
zhuanji = "\U516d\U671d";
zhuanjiid = 57;
}
 */
@interface WDHotMusicModel : WDMusicModel
@property (nonatomic, copy) NSString * zhuanji;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * zhuanjiid;
@end


/* 声音列表
 
 Json数据：
 1.title：专辑名
 2.img_url：封面图片
 3.is_top：0表示不推荐 1表示推荐
 4.is_jingxuan： 0表示不精选 1表示精选
 5.bofangliang：播放量
 6.content：简介
 7.shoucangcount：收藏统计

 Json数据，DATA：
 1.ID：数据ID
 2.category_id：分类ID
 3.sort_id:排序
 4.title：音乐标题
 5.author： 作者
 6.content：内容
 7.bofangliang：播放量
 8.yinpin：音频
 9.img_url：封面图
 10.shipin：视频
 11.leixing： 返回音频则显示音频 返回视频则显示视频
 其他数据不用理会
*/
@interface WDGetyinyueModel : WDMusicModel
@property (nonatomic, copy) NSString * is_top;
@property (nonatomic, copy) NSString * is_jingxuan;
@property (nonatomic, copy) NSString * bofangliang;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * shoucangcount;

@property (nonatomic, copy) NSArray * playMusicList;
@end

@interface WDPlayMusicListModel : WDMusicModel
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * category_id;
@property (nonatomic, copy) NSString * sort_id;
@property (nonatomic, copy) NSString * author;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * bofangliang;
@property (nonatomic, copy) NSString * yinpin;
@property (nonatomic, copy) NSString * shipin;
@property (nonatomic, copy) NSString * leixing;

@end
NS_ASSUME_NONNULL_END
