//
//  WDSignVC.m
//  WDMap
//
//  Created by wbb on 2021/3/9.
//

#import "WDSignVC.h"

@interface WDSignVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLab;

@property (nonatomic, copy) NSString * qianmingStr;
@end

@implementation WDSignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = main_background_color;
    

}
- (IBAction)saveClick:(id)sender {
    if (self.qianmingStr.length == 0) {
        [MBProgressHUD promptMessage:@"请您输入内容" inView:self.view];
        return;
    }
    if (self.textChangeBlock) {
        self.textChangeBlock(self.qianmingStr);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textViewDidChange:(UITextView *)textView {
    
    self.qianmingStr = textView.text;
    self.numLab.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.qianmingStr.length];
    
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholderLab.hidden = YES;

}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        self.placeholderLab.hidden = NO;

    }
}
@end
