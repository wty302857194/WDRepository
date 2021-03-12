//
//  WDRequestURL.h
//  NetClass
//
//  Created by wbb on 2020/3/5.
//  Copyright © 2020 WD. All rights reserved.
//

#ifndef WDRequestURL_h
#define WDRequestURL_h

/*
 
 将项目中所有的接口写在这里,方便统一管理,降低耦合
 
 这里通过宏定义来切换你当前的服务器类型,
 将你要切换的服务器类型宏后面置为真(即>0即可),其余为假(置为0)
 如下:现在的状态为测试服务器
 这样做切换方便,不用来回每个网络请求修改请求域名,降低出错事件
 */

#define DevelopSever    1  /**开发服务器*/
#define TestSever       0  /**测试服务器**/
#define ProductSever    0  /**生产服务器*/

#if DevelopSever

/**开发服务器*/
#define URL_main       @"https://wxdt.vqune.com/tools/app.ashx"

#elif TestSever

/**测试服务器**/

#define URL_main       @"http://172.16.2.72"

#elif ProductSever

/**生产服务器*/

#define URL_main       @"https://wxdt.vqune.com/tools/app.ashx"

#endif


//MARK: ------------------------------ 会员数据 ------------------------------
/// 注册协议
static NSString * const WDGetxieyiAPI  = @"?action=Getxieyi";
/// 登录接口
static NSString * const WDLoginAPI  = @"?action=Login";
/// 发送验证码
static NSString * const WDSendsmscodeAPI  = @"?action=Sendsmscode";
///  获取微信Openid
static NSString * const WDGetOpenIDAPI  = @"?action=GetOpenID";
/// 用户注册
static NSString * const WDUserRegisterAPI  = @"?action=user_register";
/// 获取用户数据
static NSString * const WDgetuserAPI  = @"?action=getuser";
/// 注册协议 Getzcxyurl
static NSString * const WDGetzcxyurlAPI  = @"?action=Getzcxyurl";
/// 文件上传
static NSString * const WDUpLoadFileAPI  = @"?action=UpLoadFile";
/// 修改用户资料
static NSString * const WDupdateuserAPI  = @"?action=updateuser";

//MARK: ------------------------------ 关于文都 ------------------------------
/// Getgywdurl
static NSString * const WDGetgywdurlAPI  = @"?action=Getgywdurl";

//MARK: ------------------------------ APP引导图 ------------------------------
/// APP引导图
static NSString * const WDGetyindaotuAPI  = @"?action=Getyindaotu";


//MARK: ------------------------------ 坐标 ------------------------------
///  景点分类
static NSString * const WDGetjingdianfenleiAPI = @"?action=Getjingdianfenlei";
/// 景点数据
static NSString * const WDGetjingdianAPI = @"?action=Getjingdian";
/// 获取景点关联人物
static NSString * const WDGetguanlianrenwuAPI = @"?action=Getguanlianrenwu";
/// 获取弹幕数据
static NSString * const WDGetdanmuAPI = @"?action=Getdanmu";
/// 发布弹幕
static NSString * const WDUserDanmuAPI = @"?action=User_danmu";

/// 地图层级scale数据   获取scale
static NSString * const WDGetscaleAPI = @"?action=Getscale";

/// 获取线路数据
static NSString * const WDGetxianluAPI = @"?action=Getxianlu";
/// 依据线路ID获取景点数据
static NSString * const WDGetxianlutoidAPI = @"?action=Getxianlutoid";

/// 年代数据
static NSString * const WDGetniandaiAPI = @"?action=Getniandai";
/// 人物数据
static NSString * const WDGetrenwuAPI = @"?action=Getrenwu";
/// 根据人物ID获取景点数据
static NSString * const WDGetjingdiantouidAPI = @"?action=Getjingdiantouid";

/*******收藏管理******/
/// 用户收藏/取消
static NSString * const WDUser_shoucangAPI = @"?action=User_shoucang";
/// 获取用户收藏信息
static NSString * const WDGetshoucangAPI = @"?action=Getshoucang";
/// 获取用户是否收藏
static NSString * const WDGetsfshoucangAPI = @"?action=Getsfshoucang";
/// 判断是否存在线路，存在则显示打卡按钮，不存在则不显示
static NSString * const WDGetsfxianluAPI = @"?action=Getsfxianlu";
/// 用户打卡
static NSString * const WDUserDakaAPI = @"?action=User_daka";
/// 获取用户是否获得勋章
static NSString * const WDGetdakaAPI = @"?action=Getdaka";
/// 获取用户勋章情况
static NSString * const WDGetxunzhangAPI = @"?action=Getxunzhang";

//MARK: ------------------------------ 常见问题 ------------------------------
/// 常见问题分类数据
static NSString * const WDGetwentifenleiAPI = @"?action=Getwentifenlei";
/// 常见问题数据
static NSString * const WDGetchangjianwentiAPI = @"?action=Getchangjianwenti";


//MARK: ------------------------------ 推荐 ------------------------------

/// 文都动态轮播图
static NSString * const WDGetbannerAPI  = @"?action=Getbanner";
/// 声音盒子轮播图
static NSString * const WDGetsyhzbannerAPI  = @"?action=Getsyhzbanner";
/// 近期活动
static NSString * const WDGetjinqihuodongAPI  = @"?action=Getjinqihuodong";
/// 书籍推荐
static NSString * const WDGetshujituijianAPI  = @"?action=Getshujituijian";
/// 文学动态
static NSString * const WDGetwenxuedongtaiAPI  = @"?action=Getwenxuedongtai";


/*****************盒子*****************/
/// 声音盒子专辑
static NSString * const WDGetyinyuefenleiAPI  = @"?action=Getyinyuefenlei";
/// 音乐 热门单曲
static NSString * const WDGethotyinyueAPI  = @"?action=Gethotyinyue";
/// 声音列表
static NSString * const WDGetyinyueAPI  = @"?action=Getyinyue";
/// 声音详细
static NSString * const WDGetyinyuetoidAPI  = @"?action=Getyinyuetoid";
/// 增加播放量
static NSString * const WDUser_addbofangliangAPI  = @"?action=User_addbofangliang";
/// 用户声音收藏/取消
static NSString * const WDUser_yyshoucangappAPI  = @"?action=User_yyshoucangapp";
/// 获取用户声音收藏信息
static NSString * const WDGetyyshoucangAPI  = @"?action=Getyyshoucang";
/// 获取用户声音收藏信息
static NSString * const WDGetyyshoucangappAPI  = @"?action=Getyyshoucangapp";
/// 获取用户声音是否收藏
static NSString * const WDGetyysfshoucangappAPI  = @"?action=Getyysfshoucangapp";
/// 获取上一条下一条的数据
static NSString * const WDgetprevandnextAPI  = @"?action=getprevandnext";
/// 获取详细内容
static NSString * const WDgetxiangxiAPI  = @"?action=getxiangxi";
/// 海报
static NSString * const WDgethaibaoAPI  = @"?action=gethaibao";
/// 获取勋章（假数据）
static NSString * const WDGetxzAPI  = @"?action=Getxz";
/// 根据关键词获取列表
static NSString * const WDGetkeyAPI  = @"?action=Getkey";

#endif /* WDRequestURL_h */
