//
//  WDScenicModel.h
//  WDMap
//
//  Created by wbb on 2021/2/25.
//

#import "WDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*

 Json数据
 1.ID：数据ID
 2.category_id：分类ID
 3.sort_id:排序
 4.title:景点名称
 5.img_url：景点图片
 6.shipin：视频地址 360视频
 7.yinpin：音频地址 文学热线
 8.jingdu：经度
 9.weidu：维度
 10.xiangxidizhi：详细地址
 11.kaifangshijian：开放时间
 12.canguanfeiyong：参观费用
 13.jingdianjieshao：景点介绍
 14.zhaiyao： 简介
 15.lianxifangshi：联系方式
 16.jingdiantouxiang：景点头像
 17.yanse 颜色
 18.wenxuerexianshifouxianshi 文学热线是否显示（1代表显示，0代表不显示）
 19.jianzhutupian 景点图片
 20.albums详情轮播图
 21.zhuyaozuobiao 主要坐标   1表示是 0表示否
 22.ciyaozuobiao 次要坐标   1表示是 0表示否
 其他数据不用理会
 */
@interface WDScenicModel : WDBaseModel
@property (nonatomic, copy) NSString * category_id;
@property (nonatomic, copy) NSString * sort_id;
@property (nonatomic, copy) NSString * shipin;
@property (nonatomic, copy) NSString * yinpin;
@property (nonatomic, copy) NSString * jingdu;
@property (nonatomic, copy) NSString * weidu;
@property (nonatomic, copy) NSString * xiangxidizhi;
@property (nonatomic, copy) NSString * kaifangshijian;
@property (nonatomic, copy) NSString * canguanfeiyong;
@property (nonatomic, copy) NSString * jingdianjieshao;
@property (nonatomic, copy) NSString * zhaiyao;
@property (nonatomic, copy) NSString * lianxifangshi;
@property (nonatomic, copy) NSString * jingdiantouxiang;
@property (nonatomic, copy) NSString * yanse;
@property (nonatomic, copy) NSString * wenxuerexianshifouxianshi;
@property (nonatomic, copy) NSString * jianzhutupian;
@property (nonatomic, copy) NSArray * albums;
@property (nonatomic, copy) NSDictionary * fields;/// jingdianjieshao
@property (nonatomic, copy) NSString * scsj;
@property (nonatomic, copy) NSString * zhuyaozuobiao;
@property (nonatomic, copy) NSString * ciyaozuobiao;

@end

@interface WDAlbumsModel : WDBaseModel
@property (nonatomic, copy) NSString * add_time;
@property (nonatomic, copy) NSString * original_path;
@property (nonatomic, copy) NSString * article_id;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * channel_id;
@property (nonatomic, copy) NSString * thumb_path;
@end


/*
 Json数据
 1:xingming：人物姓名
 2.touxiang：人物头像
 3.shifoutuijian：是否推荐（推荐的，就表示是该经典的推荐人，也就是播放语音的人）
 4.sort_id：排序
 */
@interface WDRelevancePersonModel : WDBaseModel
@property (nonatomic, copy) NSString * xingming;
@property (nonatomic, copy) NSString * touxiang;
@property (nonatomic, copy) NSString * shifoutuijian;
@property (nonatomic, copy) NSString * sort_id;

@end

@interface WDRoadModel : WDBaseModel
@property (nonatomic, copy) NSString * jindianshu;
@property (nonatomic, copy) NSArray * childrendata;
@property (nonatomic, copy) NSString * parent_id;
@property (nonatomic, copy) NSString * scale;
@property (nonatomic, copy) NSString * xianlushu;
@property (nonatomic, assign) BOOL isSelect;
@end

@interface WDRoadChildModel : WDBaseModel

@property (nonatomic, copy) NSString * scale;
@property (nonatomic, copy) NSString * parent_id;
@property (nonatomic, copy) NSArray * jingdiandata;

@end
@interface WDRoadjingdiandataModel : WDBaseModel

@property (nonatomic, copy) NSString * scale;
@property (nonatomic, copy) NSString * weidu;
@property (nonatomic, copy) NSString * jingdu;
@property (nonatomic, copy) NSString * xiangxidizhi;
@property (nonatomic, copy) NSString * guanjiangaiyao;

@end

NS_ASSUME_NONNULL_END
