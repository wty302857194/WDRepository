//
//  WDEditProfileVC.m
//  WDMap
//
//  Created by wbb on 2021/3/9.
//

#import "WDEditProfileVC.h"
#import "WDSignVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

@interface WDEditProfileVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *cornerView;


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *genderLab;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *genderView;
@property (weak, nonatomic) IBOutlet UIView *genderTopView;
@property (weak, nonatomic) IBOutlet UIView *genderMidView;
@property (weak, nonatomic) IBOutlet UIView *genderEndView;
@property (weak, nonatomic) IBOutlet UIView *endView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mid_height_layout;
@property (weak, nonatomic) IBOutlet UITextField *nichengTF;
@property (weak, nonatomic) IBOutlet UILabel *qianMingLab;

@property (nonatomic, assign) BOOL isExpansion;
@property (nonatomic, copy) NSString * nichengStr;
@property (nonatomic, copy) NSString * qianmingStr;
@property (nonatomic, copy) NSString * genderStr;

@property (nonatomic, strong) UIImagePickerController * imagePickerController;
@end

@implementation WDEditProfileVC
- (IBAction)tfChange:(UITextField *)sender {
    if (sender == self.nichengTF) {
        self.nichengStr = sender.text;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.topView addTarget:self action:@selector(nicheng)];
    [self.genderTopView addTarget:self action:@selector(expansion)];
    [self.genderMidView addTarget:self action:@selector(man)];
    [self.genderEndView addTarget:self action:@selector(women)];
    [self.userImageView addTarget:self action:@selector(tapAvatar)];

    
    [self.endView addTarget:self action:@selector(qianming)];

    self.genderStr = @"女";
    self.qianMingLab.text = @"";
}
- (void)tapAvatar {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self checkCameraPermission];//检查相机权限
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self checkAlbumPermission];//检查相册权限
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

    [alert addAction:camera];
    [alert addAction:album];
    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Camera
- (void)checkCameraPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self takePhoto];
            }
        }];
    } else if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [self takePhoto];
    } else {
        [self takePhoto];
    }
}

- (void)takePhoto {
    //判断相机是否可用，防止模拟器点击【相机】导致崩溃
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:^{

        }];
    } else {
        NSLog(@"不能使用模拟器进行拍照");
    }
}
#pragma mark - Album
- (void)checkAlbumPermission {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self selectAlbum];
                }
            });
        }];
    } else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        [self alertAlbum];
    } else {
        [self selectAlbum];
    }
}

- (void)selectAlbum {
    //判断相册是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:^{

        }];
    }
}

- (void)alertAlbum {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请在设置中打开相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    self.userImageView.image = image;
}


- (void)nicheng {
    [self.nichengTF becomeFirstResponder];
}
- (void)qianming {
    WDSignVC *vc = [[WDSignVC alloc] init];
    kWEAK_SELF;
    vc.textChangeBlock = ^(NSString * _Nonnull text) {
        weakSelf.qianmingStr = text;
        weakSelf.qianMingLab.text = text;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)expansion {
    if(!self.isExpansion) {
        self.mid_height_layout.constant = 150;
        self.genderMidView.hidden = NO;
        self.genderEndView.hidden = NO;
    }else {
        self.mid_height_layout.constant = 50;
        self.genderMidView.hidden = YES;
        self.genderEndView.hidden = YES;
    }
    self.isExpansion = !self.isExpansion;
}
- (void)man {
    self.genderLab.text = @"男";
    self.genderStr = @"男";
    self.isExpansion = YES;
    [self expansion];
}
- (void)women {
    self.genderLab.text = @"女";
    self.genderStr = @"女";
    self.isExpansion = YES;
    [self expansion];

}
- (IBAction)save:(id)sender {
    if (self.nichengStr.length == 0) {
        [MBProgressHUD promptMessage:@"请输入您的昵称" inView:self.view];
        return;
    }
    if (self.qianmingStr.length == 0) {
        [MBProgressHUD promptMessage:@"请输入您的签名" inView:self.view];
        return;
    }
    
    
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [WDGlobal addCorners:self.backView];

}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self; //delegate遵循了两个代理
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}
@end
