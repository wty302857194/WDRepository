//
//  WDMusicMenuView.m
//  WDMap
//
//  Created by wbb on 2021/2/20.
//

#import "WDMusicMenuView.h"
#import "WDMusicMenuTvCell.h"
#import "WDMusicModel.h"

@interface WDMusicMenuView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *contentBackView;
@property (weak, nonatomic) IBOutlet UILabel *playNumLab;
@property (weak, nonatomic) IBOutlet UIButton *loopBtn;

/// 音乐列表
@property (nonatomic, strong) NSMutableArray * musicArr;
/// 音乐索引
@property (nonatomic, assign) NSInteger musicIndex;
@end
@implementation WDMusicMenuView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.backView addTarget:self action:@selector(hidden)];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [WDGlobal addCorners:self.contentBackView];
}
- (void)musicArray:(NSMutableArray *)musicArr index:(NSInteger)index {
    self.musicArr = musicArr;
    self.musicIndex = index;
    
    self.playNumLab.text = [NSString stringWithFormat:@"（%lu）",(unsigned long)musicArr.count];
    [self.tableView reloadData];
}
#pragma mark -  TODO：这里修改图片
- (void)setRunLoopType:(MusicRunLoopType)runLoopType {
    _runLoopType = runLoopType;
    NSString *imgStr = @"";
    switch (runLoopType) {
        case MusicRunLoopShunXun:
        {
            imgStr = @"voice_box_shunxu";
        }
            break;
        case MusicRunLoopSuiji:
        {
            imgStr = @"voice_box_suiji";
        }
            break;
        case MusicRunLoopDanqu:
        {
            imgStr = @"voice_box_danqu";
        }
            break;
        default:
            break;
    }
    [self.loopBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
}
- (IBAction)loopClick:(UIButton *)sender {
    if (self.currentLoopBlock) {
        self.currentLoopBlock();
    }
}

- (IBAction)deletClick:(UIButton *)sender {
    if (self.deletItemBlock) {
        self.deletItemBlock(0, YES);
    }
    [self hidden];
}
- (void)hidden {
    self.hidden = YES;
}
#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDMusicMenuTvCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDMusicMenuTvCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"WDMusicMenuTvCell" owner:nil options:nil].lastObject;
    }
    kWEAK_SELF;
    cell.deleItemtBlock = ^{
        if (weakSelf.deletItemBlock) {
            weakSelf.deletItemBlock(indexPath.row, NO);
        }
    };
    if (indexPath.row < self.musicArr.count) {
        WDPlayMusicListModel *model = self.musicArr[indexPath.row];
        cell.musicModel = model;
        
        if (self.musicIndex == indexPath.row) {
            cell.isChoose = YES;
        }else {
            cell.isChoose = NO;
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectItemBlock) {
        self.selectItemBlock(indexPath.row);
    }
}
@end
