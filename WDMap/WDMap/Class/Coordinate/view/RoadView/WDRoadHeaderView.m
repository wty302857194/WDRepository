//
//  WDRoadHeaderView.m
//  WDMap
//
//  Created by wbb on 2021/2/8.
//

#import "WDRoadHeaderView.h"
#import "WDScenicModel.h"

@implementation WDRoadHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.backView addTarget:self action:@selector(touchClick)];

}
- (void)drawRect:(CGRect)rect {
    [WDGlobal addShadow:self.backView cornerRadius:self.backView.height/2.f];

}
- (void)setModel:(WDRoadModel *)model {
    _model = model;
    self.titleLab.text = model.title;
    self.address_num_lab.text = model.xianlushu;
    self.tag_num_lab.text = model.jindianshu;
    if (model.isSelect) {
        [self select];
    }else {
        [self normal];
    }
}
- (void)touchClick {    
    if (self.rodeHeaderBlock) {
        self.rodeHeaderBlock();
    }
    
}

- (void)select {
    self.backView.backgroundColor = main_color;
//    self.titleLab.textColor = [UIColor whiteColor];
//    self.address_num_lab.textColor = hexColor(32fae6);
//    self.tag_num_lab.textColor = hexColor(e632fa);
//    self.roadImgView.image = [UIImage imageNamed:@"coordinate_tag_select"];
//    self.addressImgView.image = [UIImage imageNamed:@"coordinate_location_select"];

}
- (void)normal {
    self.backView.backgroundColor = hexColor(befff0);

//    self.backView.backgroundColor = [UIColor whiteColor];
//    self.titleLab.textColor = hexColor(575757);
//    self.address_num_lab.textColor = hexColor(575757);
//    self.tag_num_lab.textColor = hexColor(575757);
//    self.roadImgView.image = [UIImage imageNamed:@"coordinate_tag"];
//    self.addressImgView.image = [UIImage imageNamed:@"coordinate_location"];
}
@end
