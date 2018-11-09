//
//  SGQRCodeScanningVC.m
//  SGQRCodeExample
//
//  Created by apple on 17/3/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SGQRCodeScanningVC.h"
#import "SGQRCode.h"
#import "ScanSuccessJumpVC.h"
//#import "HXRecordScannAPI.h"
#import "HHCurrentStoreVC.h"

@interface SGQRCodeScanningVC () <SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@end

@implementation SGQRCodeScanningVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}

- (void)dealloc {
    NSLog(@"SGQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scanningView];
    [self setupNavigationBar];
    [self setupQRCodeScanning];
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [SGQRCodeScanningView scanningViewWithFrame:self.view.bounds layer:self.view.layer];
    }
    return _scanningView;
}
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    
    self.scanningView = nil;
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"扫一扫";
    
    UIButton *backBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 30, 30) target:self action:@selector(backAction) image:[UIImage imageNamed:@"icon_return_default"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

     UIButton *photosBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 30, 30) target:self action:@selector(rightBarButtonItenAction) image:nil];
    [photosBtn setTitle:@"相册" forState:UIControlStateNormal];
    photosBtn.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:photosBtn];
   
}
- (void)backAction {

    [self.navigationController popVC];
    
}
- (void)rightBarButtonItenAction {

    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager SG_readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 栅栏函数
    dispatch_barrier_async(queue, ^{
        BOOL isPHAuthorization = manager.isPHAuthorization;
        if (isPHAuthorization == YES) {
//          [self removeScanningView];
        }
    });
}

- (void)setupQRCodeScanning {
    SGQRCodeScanManager *manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [manager SG_setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    manager.delegate = self;
}

#pragma mark - - - SGQRCodeAlbumManagerDelegate
- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    
    NSLog(@"result:%@",result);
    
}

#pragma mark - - - SGQRCodeScanManagerDelegate
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [scanManager SG_palySoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager SG_stopRunning];
        [scanManager SG_videoPreviewLayerRemoveFromSuperlayer];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        //users_id=24&teacher_id=9&transactionrecord_id=1
        NSString *infoStr = [obj stringValue];

        NSDictionary *dic=[infoStr mj_JSONObject];
        
        if (infoStr.length>0) {
            HHQRCodeModel *model = [HHQRCodeModel mj_objectWithKeyValues:dic];
            if (model.userid.length>0) {
                [[[HHHomeAPI postLoginShopWithuserid:model.userid] netWorkClient] postRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
                    if (!error) {
                        if (api.code == 0) {
                            HHMineModel *model1 = [HHMineModel mj_objectWithKeyValues:api.data];
                            HJUser *user = [HJUser sharedUser];
                            user.is_login_shop = model1.is_login_shop;
                            user.login_userid = model1.login_userid;
                            user.login_username = model1.login_username;
                            [user write];
                            
                            if (self.isHome_enter) {
                                //首页进入--->跳转到当前店长账号
                                HHCurrentStoreVC *vc = [HHCurrentStoreVC new];
                                vc.store_num =  model1.login_userid;
                                vc.isHome_enter = YES;
                                [self.navigationController pushVC:vc];
                            }else{
                                [self.navigationController popVC];
                            }
                            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"欢迎进入%@的体验店～",model1.login_username]];
                           
                        }else{
                            [SVProgressHUD showInfoWithStatus:api.msg];
                            [self.navigationController popVC];
                        }
                    }else{
                        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
                        [self.navigationController popVC];

                    }
                }];
                
            }else{
                //其他的数据
                        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
                        jumpVC.jump_URL = [obj stringValue];
                        [self.navigationController pushViewController:jumpVC animated:YES];
            }
            
        }else{
            [SVProgressHUD showInfoWithStatus:@"未识别此图片"];
            [self.navigationController popVC];
        }


        
        
 
        
    } else {
        NSLog(@"暂未识别出扫描的二维码");
    }
}


@end

