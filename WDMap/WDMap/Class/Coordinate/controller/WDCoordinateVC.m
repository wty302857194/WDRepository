
//
//  WDCoordinateVC.m
//  WDMap
//
//  Created by wbb on 2021/1/29.
//

#import "WDCoordinateVC.h"
#import "WDSearchHistoryView.h"
#import "WDScenicMenuView.h"
#import "WDScenicView.h"
#import <TencentLBS/TencentLBS.h>
#import "WDRoadView.h"
#import "WDRoadDetailView.h"
#import "WDScenicClassifyModel.h"
#import "WDScenicModel.h"
/*
 主要坐标：min_scale  <=  当前层级  >moren_scale
 次要坐标：moren_scale  <=  当前层级 >max_scale
 最小层级：当前层级 = max_scale   显示所有景点+景点名称
 */
typedef NS_ENUM(NSUInteger, ZoomLevelState) {
    ZoomLevelMin,
    ZoomLevelDefault,
    ZoomLevelMax,
};

@interface QRouteOverlay : QPolyline

- (id)initWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count arrLine:(NSArray<QSegmentStyle*> *)arrLine;

// 保存折线每条线段的分段信息
@property(nonatomic, strong) NSMutableArray<QSegmentStyle *>* arrLine;

@end

@implementation QRouteOverlay

- (id)initWithCoordinates:(CLLocationCoordinate2D *)coordinateArray count:(NSUInteger)count arrLine:(NSArray<QSegmentStyle *> *)arrLine
{
    if (count == 0 || arrLine.count == 0) {
        return nil;
    }
    
    if (self = [super initWithCoordinates:coordinateArray count:count])
    {
        self.arrLine = [NSMutableArray array];
        [self.arrLine addObjectsFromArray:arrLine];
    }
    
    return self;
}

@end



@interface WDCoordinateVC ()<QMapViewDelegate,TencentLBSLocationManagerDelegate>

@property (readwrite, nonatomic, strong) TencentLBSLocationManager *locationManager;
@property (nonatomic, strong) QMapView *mapView;
@property (nonatomic, strong) WDSearchHistoryView *searchView;
@property (nonatomic, strong) WDScenicMenuView *menuView;
//@property (nonatomic, strong) WDMenuView *childMenuView;

@property (nonatomic, strong) WDScenicView *scenicView;
@property (nonatomic, strong) WDRoadView * roadView;
@property (nonatomic, strong) WDRoadDetailView * roadDetailView;

@property (nonatomic, copy) NSArray * menuArr;/// 景点分类数据源
@property (nonatomic, copy) NSArray * scenicArr;/// 景点数据源
@property (nonatomic, strong) UIButton *lefMenutBtn;
@property (nonatomic, assign) NSInteger count;

/// 是否是通过搜索获取的数据
@property (nonatomic, assign) BOOL isSearch;

//@property (nonatomic, strong) NSMutableArray<QPolyline *> *lines;
@property (nonatomic, assign) CGFloat minLevel;
@property (nonatomic, assign) CGFloat maxLevel;
@property (nonatomic, assign) CGFloat moren_scale;

@property (nonatomic, assign) ZoomLevelState zoomLevelState;

/// 判断是否添加覆盖物
@property (nonatomic, assign) BOOL isOverlay;
@end

@implementation WDCoordinateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文都地图";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.zoomLevelState = ZoomLevelDefault;
    
    /// 初始化ui
    [self addBarButtonItem];
    [self initMap];
    [self configLocationManager];
    [self initUI];
    [self initWithData];
    
    /// 接口调用
    [self getjingdianfenleiRequestData];
    [self getjingdianRequestData:@"" fenleiid:@"0" pageSize:@"" key:@""];
    [self GetscaleRequestData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([WDGlobal shareInstance].scenicModel) {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([[WDGlobal shareInstance].scenicModel.jingdu floatValue], [[WDGlobal shareInstance].scenicModel.weidu floatValue]) animated:YES];
        self.scenicView.hidden = NO;
        self.scenicView.model = [WDGlobal shareInstance].scenicModel;
        
        [WDGlobal shareInstance].scenicModel = nil;
    }
}
- (void)initWithData {
    self.count = 0;
}
#pragma mark - 初始化地图
- (void)initMap {
    //初始化地图实例
    self.mapView = [[QMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.shows3DBuildings = NO;
    self.mapView.overlookingEnabled = NO;
    self.mapView.rotateEnabled = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(32.083581, 118.792624) animated:YES];
    });
    //接受地图的delegate回调
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    // case3: 设置为3（在配置列表中，第3个是白浅）
    [self.mapView setMapStyle:3];
    //把mapView添加到view中进行显示
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (void)initUI {
    
    float width = 80;
    for (int i=0; i<2; i++) {
        UIButton *clickBtn = [UIButton buttonWithBackgroundImage:[NSString stringWithFormat:@"recommend_road%d",i] target:self action:@selector(tagClick:)];
        clickBtn.frame = CGRectMake(kSCREEN_WIDTH - width -10, self.view.centerY +(width + 10) * i, width, width);
        clickBtn.tag = i + 1000;
        [self.view addSubview:clickBtn];
    }
    
    self.searchView.hidden = NO;
    
    [self addLefMenuBtn];
    
}
- (void)tagClick:(UIButton *)btn {
    if (btn.tag == 1000) {
        self.roadView.hidden = NO;
    }else {
        [self startSingleLocation];
    }
}
/// MARK : BarButtonItem
- (void)addBarButtonItem {
    UIButton *left_home = [UIButton buttonWithType:UIButtonTypeCustom];
    [left_home setBackgroundImage:[UIImage imageNamed:@"recommend_home"] forState:UIControlStateNormal];
    left_home.frame = CGRectMake(0, 0, 25, 25);
    [left_home addTarget:self action:@selector(leftHomeClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_home];
    
}
- (void)leftHomeClick {
    [kDelegate rootHomeVC];
}


/// MARK: 左边按钮
- (void)addLefMenuBtn {
    CGFloat width = 22;
    UIButton *lefMenuBtn = [UIButton buttonWithBackgroundImage:@"Coordinate_left_aleart" target:self action:@selector(menuCkick)];
    lefMenuBtn.frame = CGRectMake(0, 0, width, width*88/22.f);
    lefMenuBtn.center = CGPointMake(width/2.f, self.view.centerY-100);
    [self.view addSubview:lefMenuBtn];
    self.lefMenutBtn = lefMenuBtn;
}


- (void)menuCkick {
    if (self.menuArr && self.menuArr.count > 0) {
        [self.menuView show];
    }
    
}
#pragma mark - delegate
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        static NSString *annotationIdentifier = @"pointAnnotation";
        //        QPinAnnotationView *pinView = (QPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        QAnnotationView *pinView = (QAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pinView == nil) {
            pinView = [[QAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            pinView.image = [UIImage imageNamed:@"recommend_green_tag"];
            pinView.canShowCallout = YES;
            
        }
        
        return pinView;
    }
    
    return nil;
}
// 当选中一个annotation view时，调用此接口
- (void)mapView:(QMapView *)mapView didSelectAnnotationView:(QAnnotationView *)view {
    [view setSelected:NO];
    self.scenicView.hidden = NO;
    NSInteger index = [mapView.annotations indexOfObject:view.annotation];
    if (index< self.scenicArr.count) {
        WDScenicModel *model = self.scenicArr[index];
        self.scenicView.model = model;
    }
    
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]])
    {
        //        QRouteOverlay *ro = (QRouteOverlay*)overlay;
        //        QTexturePolylineView *polylineRender = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        //
        //        // 设置分段样式
        //        polylineRender.segmentStyle = ro.arrLine;
        //        polylineRender.lineWidth = 10;
        //        // 开启箭头绘制
        //        polylineRender.drawSymbol = YES;
        //        // 设置箭头之间的间距
        //        polylineRender.symbolGap = 52;
        
        QPolylineView *polylineRender = [[QPolylineView alloc] initWithPolyline:overlay];
        polylineRender.lineWidth   = 6;
        polylineRender.strokeColor = hexColor(999999);
        
        // 设置overlay虚线样式
        [polylineRender setLineDashPattern:[NSArray<NSNumber*> arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:10],[NSNumber numberWithInt:10],[NSNumber numberWithInt:10], nil]];
        
        return polylineRender;
    }
    
    return nil;
}
- (void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture {
    if (!bGesture) return;
    if (self.isOverlay) return;
    
    CGFloat currentLevel =  mapView.zoomLevel;
    if (currentLevel >= self.minLevel && currentLevel < self.moren_scale) {
        self.zoomLevelState = ZoomLevelMin;
    }else if (currentLevel >= self.moren_scale && currentLevel < self.maxLevel) {
        self.zoomLevelState = ZoomLevelDefault;
    }else {
        self.zoomLevelState = ZoomLevelMax;
    }
    [self addPointAnnotation];
}
#pragma mark - 定位
- (void)configLocationManager
{
    self.locationManager = [[TencentLBSLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setApiKey:WD_apiKey];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    // 需要后台定位的话，可以设置此属性为YES。
    //    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    // 如果需要POI信息的话，根据所需要的级别来设定，定位结果将会根据设定的POI级别来返回，如：
    //    [self.locationManager setRequestLevel:TencentLBSRequestLevelName];
    
    // 申请的定位权限，得和在info.list申请的权限对应才有效
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

// 单次定位
- (void)startSingleLocation {
    kWEAK_SELF;
    [self.locationManager requestLocationWithCompletionBlock:
     ^(TencentLBSLocation *location, NSError *error) {
        NSLog(@"%@, %@, %@", location.location, location.name, location.address);
        [weakSelf.mapView setCenterCoordinate:location.location.coordinate animated:YES];
        
    }];
}

// 连续定位
- (void)startSerialLocation {
    //开始定位
    [self.locationManager startUpdatingLocation];
}

- (void)stopSerialLocation {
    //停止定位
    [self.locationManager stopUpdatingLocation];
}

- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager
                 didFailWithError:(NSError *)error {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusDenied ||
        authorizationStatus == kCLAuthorizationStatusRestricted) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"定位权限未开启，是否开启？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"是"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
            if( [[UIApplication sharedApplication]canOpenURL:
                 [NSURL URLWithString:UIApplicationOpenSettingsURLString]] ) {
                [[UIApplication sharedApplication] openURL:
                 [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"否"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [self presentViewController:alert animated:true completion:nil];
        
    } else {
        
    }
}


- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager
                didUpdateLocation:(TencentLBSLocation *)location {
    //定位结果
    NSLog(@"location:%@", location.location);
}

#pragma mark - network
- (void)getjingdianfenleiRequestData {
    [TYNetworkTool getRequest:WDGetjingdianfenleiAPI parameters:@{} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            self.menuArr = [WDScenicClassifyModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [self menuCkick];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
/// 景点数据
- (void)getjingdianRequestData:(NSString *)idStr fenleiid:(NSString *)fenleiid pageSize:(NSString *)pageSize key:(NSString *)key {
    NSDictionary *dic = @{
        @"id" : idStr,
        @"fenleiid" : fenleiid,
        @"pageSize" : pageSize,
        @"pageIndex" : @(self.count),
        @"key" : key,
    };
    [TYNetworkTool getRequest:WDGetjingdianAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            self.scenicArr = [WDScenicModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (self.isSearch) {
                CGFloat height = self.scenicArr.count == 0 ? 40 : 40*self.scenicArr.count;
                if (height > 300) {
                    height = 300;
                }
                self.searchView.frame = CGRectMake(40, 20, kSCREEN_WIDTH - 80, height);
                self.searchView.dataArr = self.scenicArr;
            }else {
                [self addPointAnnotation];
            }
            
            
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
/// 获取地图层级
- (void)GetscaleRequestData {
    NSDictionary *dic = @{
        
    };
    [TYNetworkTool postRequest:WDGetscaleAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:data];
            
            self.minLevel = [dic[@"min_scale"] floatValue];
            self.maxLevel = [dic[@"max_scale"] floatValue];
            self.moren_scale = [dic[@"moren_scale"] floatValue];
            [self.mapView setMinZoomLevel:self.minLevel maxZoomLevel:self.maxLevel];
            [self.mapView setZoomLevel:self.moren_scale animated:YES];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
- (void)addPointAnnotation {
    self.isOverlay = NO;
    
    [self.mapView removeOverlays:self.mapView.overlays];

    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (WDScenicModel *model in self.scenicArr) {
        switch (self.zoomLevelState) {
            case ZoomLevelMin:
            {
                if ([model.zhuyaozuobiao isEqualToString:@"1"]) {
                    QPointAnnotation *pointAnnotation = [[QPointAnnotation alloc] init];
                    pointAnnotation.coordinate = CLLocationCoordinate2DMake([model.jingdu floatValue], [model.weidu floatValue]);
                    // 将点标记添加到地图中
                    [self.mapView addAnnotation:pointAnnotation];
                }
            }
                break;
            case ZoomLevelDefault:
            {
                if ([model.ciyaozuobiao isEqualToString:@"1"]) {
                    QPointAnnotation *pointAnnotation = [[QPointAnnotation alloc] init];
                    pointAnnotation.coordinate = CLLocationCoordinate2DMake([model.jingdu floatValue], [model.weidu floatValue]);
                    // 将点标记添加到地图中
                    [self.mapView addAnnotation:pointAnnotation];
                }
            }
                break;
            case ZoomLevelMax:
            {
                QPointAnnotation *pointAnnotation = [[QPointAnnotation alloc] init];
                pointAnnotation.title = model.title;
                pointAnnotation.coordinate = CLLocationCoordinate2DMake([model.jingdu floatValue], [model.weidu floatValue]);
                // 将点标记添加到地图中
                [self.mapView addAnnotation:pointAnnotation];
                
            }
                break;
            default:
                break;
        }
        
    }
}
#pragma mark - searchView
- (WDSearchHistoryView *)searchView {
    if (!_searchView) {
        _searchView = [[WDSearchHistoryView alloc] initWithFrame:CGRectMake(40, 20, kSCREEN_WIDTH - 80, 40)];
        
        [self.view addSubview:_searchView];
        kWEAK_SELF;
        _searchView.textChangeBlock = ^(NSString * _Nonnull text) {
            weakSelf.isSearch = YES;
            [weakSelf getjingdianRequestData:@"" fenleiid:@"" pageSize:@"9999" key:text];
        };
        _searchView.selectItemBlock = ^(WDScenicModel * _Nonnull model) {
            weakSelf.searchView.frame = CGRectMake(40, 20, kSCREEN_WIDTH - 80, 40);
            [weakSelf.mapView removeOverlays:weakSelf.mapView.overlays];

            [weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
            
            weakSelf.isOverlay = YES;
            
            QPointAnnotation *pointAnnotation = [[QPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([model.jingdu floatValue], [model.weidu floatValue]);
            // 将点标记添加到地图中
            [weakSelf.mapView addAnnotation:pointAnnotation];
            
            [weakSelf.mapView setCenterCoordinate:CLLocationCoordinate2DMake([model.jingdu floatValue], [model.weidu floatValue]) animated:YES];
        };
    }
    return _searchView;
}
- (WDScenicMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[WDScenicMenuView alloc] initWithFrame:CGRectMake(0, 0, 70+28, self.view.height) withMenuList:self.menuArr?:@[]];
        [self.view addSubview:_menuView];
        kWEAK_SELF;
        _menuView.menuTouchBlock = ^(WDScenicClassifyModel * _Nonnull model) {
            [weakSelf getjingdianRequestData:@"" fenleiid:model.ID pageSize:@"9999" key:@""];
        };
    }
    return _menuView;
}

- (WDScenicView *)scenicView {
    if (!_scenicView) {
        _scenicView = [WDScenicView shareInstance];
        [self.view addSubview:_scenicView];
        kWEAK_SELF;
        _scenicView.touchHiddenBlock = ^{
            [weakSelf.scenicView removeFromSuperview];
            weakSelf.scenicView = nil;
        };
        [_scenicView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return _scenicView;
}
- (WDRoadView *)roadView {
    if (!_roadView) {
        _roadView = [WDRoadView roadView];
        [self.view addSubview:_roadView];
        kWEAK_SELF;
        _roadView.touchHiddenBlock = ^{
            [weakSelf.roadView removeFromSuperview];
            weakSelf.roadView = nil;
        };
        _roadView.roadDetailBlock = ^(NSString *xlid) {
            [weakSelf.roadView removeFromSuperview];
            weakSelf.roadView = nil;
            weakSelf.roadDetailView.hidden = NO;
            
            [weakSelf roadDetailView:xlid];
        };
        [_roadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return _roadView;
}
- (void)roadDetailView:(NSString *)xlid {
    kWEAK_SELF;
    [self.roadDetailView GetxianlutoidRequestData:xlid successBlock:^(NSArray * _Nonnull dataArr) {
        [weakSelf addOverlay:dataArr];
    }];
}
- (void)addOverlay:(NSArray *)dataArr {
    self.isOverlay = YES;
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    const NSInteger COUNT = dataArr.count;
    CLLocationCoordinate2D polylineCoords[COUNT];
    
    CLLocationCoordinate2D topLeftCoord;
    CLLocationCoordinate2D bottomRightCoord;
    topLeftCoord.latitude = 0;
    topLeftCoord.longitude = 0;
    bottomRightCoord.latitude = 0;
    bottomRightCoord.longitude = 0;
    for (int i=0; i<COUNT; i++) {
        WDRoadjingdiandataModel *model = dataArr[i];
        polylineCoords[i].latitude = [WDGlobal jingdu:model.jingdu];
        polylineCoords[i].longitude = [WDGlobal jingdu:model.weidu];
        
        if(topLeftCoord.longitude == 0) {
            topLeftCoord.longitude = [WDGlobal jingdu:model.weidu];
        }else {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, [WDGlobal jingdu:model.weidu]);
        }
        if(topLeftCoord.latitude == 0) {
            topLeftCoord.latitude = [WDGlobal jingdu:model.jingdu];
        }else {
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, [WDGlobal jingdu:model.jingdu]);
        }
        
        if(bottomRightCoord.longitude == 0) {
            bottomRightCoord.longitude = [WDGlobal jingdu:model.weidu];
        }else {
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, [WDGlobal jingdu:model.weidu]);
        }
        if(bottomRightCoord.latitude == 0) {
            bottomRightCoord.latitude = [WDGlobal jingdu:model.jingdu];
        }else {
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, [WDGlobal jingdu:model.jingdu]);
        }

        
        QPointAnnotation *pointAnnotation = [[QPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([model.jingdu floatValue], [model.weidu floatValue]);
        // 将点标记添加到地图中
        [self.mapView addAnnotation:pointAnnotation];
    }
    
    QCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    [self.mapView setRegion:region
                edgePadding:UIEdgeInsetsMake(10, 10, 10, 10)
                   animated:YES];
    
    /// TODO: 这里是添加的纹理
//    NSMutableArray* routeLineArray = [NSMutableArray array];
//    for (int i = 0; i < COUNT-1; i++)
//    {
//        QSegmentStyle *subLine = [[QSegmentStyle alloc] init];
//        subLine.startIndex = i;
//        subLine.endIndex  = i+1;
//        subLine.colorImageIndex = 9;///arc4random() % 6;
//        [routeLineArray addObject:subLine];
//    }
//    QRouteOverlay *polyline = [[QRouteOverlay alloc] initWithCoordinates:polylineCoords count:COUNT arrLine:routeLineArray];
//    [self.mapView addOverlay:polyline];
    QPolyline *polyline = [QPolyline polylineWithCoordinates:polylineCoords count:COUNT];
    // 将折线数据对象添加到地图中
    [self.mapView addOverlay:polyline];
}
- (WDRoadDetailView *)roadDetailView {
    if (!_roadDetailView) {
        _roadDetailView = [WDRoadDetailView shareInstance];
        [self.view addSubview:_roadDetailView];
        kWEAK_SELF;
        _roadDetailView.locationBlock = ^(CGPoint point) {
            
            [weakSelf.mapView setCenterCoordinate:CLLocationCoordinate2DMake(point.x, point.y) animated:YES];
            
        };
        [_roadDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return _roadDetailView;
}


@end





