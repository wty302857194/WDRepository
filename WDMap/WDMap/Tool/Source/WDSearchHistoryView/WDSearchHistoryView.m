//
//  WDSearchHistoryView.m
//  WDMap
//
//  Created by wbb on 2021/1/30.
//

#import "WDSearchHistoryView.h"
#import "WDScenicModel.h"

static NSInteger const cellHeight = 40;

@interface WDSearchHistoryView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSString *searchStr;
@property (nonatomic, strong) UITableView * tableView;
@end
@implementation WDSearchHistoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10;
        self.alpha = 0.8;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowOpacity = 0.8;
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    
    UIView *searchBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
    [self addSubview:searchBackView];
    
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, self.width, 30)];
    phoneTF.placeholder = @"请输入您想搜索的景点";
    phoneTF.font = [UIFont systemFontOfSize:15];
    [phoneTF addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [searchBackView addSubview:phoneTF];
    
    UIButton *searchBtn = [UIButton buttonWithImageName:@"coordinate_search" selectImageName:@"coordinate_search" target:self action:@selector(searchClick)];
    searchBtn.frame = CGRectMake(self.width - 30, 5, 30, 30);
    [searchBackView addSubview:searchBtn];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBackView.frame), self.width, 0) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.top.equalTo(searchBackView.mas_bottom);
    }];
}
- (void)textChange:(UITextField *)textField {
    self.searchStr = textField.text;

    if(!self.isNotValueChange) {
        if (self.textChangeBlock) {
            self.textChangeBlock(self.searchStr);
        }
    }
    
}
- (void)searchClick {
    if (self.isNotValueChange) {
        if (self.textChangeBlock) {
            self.textChangeBlock(self.searchStr);
        }
    }
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    [self.tableView reloadData];
}
#pragma mark - delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    WDScenicModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WDScenicModel *model = self.dataArr[indexPath.row];

    if (self.selectItemBlock) {
        self.selectItemBlock(model);
    }
}
@end
