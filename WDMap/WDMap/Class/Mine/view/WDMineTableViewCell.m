//
//  WDMineTableViewCell.m
//  WDMap
//
//  Created by wbb on 2021/2/7.
//

#import "WDMineTableViewCell.h"
#import "WDMineModel.h"
#import "WDScenicModel.h"

@implementation WDMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [WDGlobal addShadow:self.backView];
}

- (void)drawRect:(CGRect)rect {
    
}
- (IBAction)moreClick:(UIButton *)sender {
    if (self.moreBlock) {
        self.moreBlock();
    }
}
- (void)cellForDataSource:(NSDictionary *)dic indexPath:(NSInteger)index {
    if (index == 0) {
        self.titlelab.text = @"我的景点";
        NSString *str = [NSString stringWithFormat:@"%@", dic[@"totalcount"]?:@"0"];
        self.numLab.text = [NSString stringWithFormat:@"共计%@个", str];
        NSArray *scenicArr = [WDScenicModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        scenicArr = [scenicArr subarrayWithRange:NSMakeRange(0, 4)];
        
        for (int i = 0; i < scenicArr.count; i++) {
            WDScenicModel * model = scenicArr[i];
            if (i == 0) {
                [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:PLACE_HOLDER_IMAGE];
            }else if(i == 1) {
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:PLACE_HOLDER_IMAGE];
            }else if(i == 2) {
                [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:PLACE_HOLDER_IMAGE];
            }else if(i == 3) {
                [self.imageView4 sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:PLACE_HOLDER_IMAGE];
            }
        }
    }else {
        self.titlelab.text = @"我的勋章";
        NSString *str = [NSString stringWithFormat:@"%@", dic[@"xunzhangshu"]?:@"0"];
        self.numLab.text = [NSString stringWithFormat:@"共计%@个",str];

        NSArray *xunzhangArr = [WDMineXunzhangModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        xunzhangArr = [xunzhangArr subarrayWithRange:NSMakeRange(0, 4)];
        
        for (int i = 0; i < xunzhangArr.count; i++) {
            WDMineXunzhangModel * model = xunzhangArr[i];
            UIImageView *imgView = nil;
            if (i == 0) {
                imgView = self.imageView1;
            }else if(i == 1) {
                imgView = self.imageView2;
            }else if(i == 2) {
                imgView = self.imageView3;
            }else {
                imgView = self.imageView4;
            }
            [imgView sd_setImageWithURL:[NSURL URLWithString:model.appxunzhang] placeholderImage:PLACE_HOLDER_IMAGE];
        }
    }
}
@end
