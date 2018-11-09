//
//  HHAuthenticationVC2.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHAuthenticationVC2.h"
#import "HHidentityCell.h"
#import "HHTextfieldcell.h"

@interface HHAuthenticationVC2 ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *leftTitleArr;
@property(nonatomic,strong)NSArray *placeholerArr;
@property(nonatomic,strong)NSString *front_imgPath;
@property(nonatomic,strong)NSString *back_imgPath;


@end

@implementation HHAuthenticationVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"特殊认证";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH,SCREEN_HEIGHT-64-44) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHidentityCell" bundle:nil] forCellReuseIdentifier:@"HHidentityCell"];
    
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) backColor:KVCBackGroundColor];
    
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, WidthScaleSize_H(40)) target:self action:@selector(finishAction) backgroundImage:nil title:@"提交" titleColor:kWhiteColor font:FONT(15)];
    finishBtn.backgroundColor = APP_COMMON_COLOR;
    [finishBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tableView.tableFooterView = footView;
    
    self.placeholerArr = @[@"点击编辑姓名",@"点击编辑身份证号",@""];
    
    self.leftTitleArr = @[@"姓名",@"身份证号",@"证件照（*国际+港澳台用户才需上传）"];
    
    UIView *emptyView = [UIView lh_viewWithFrame:CGRectMake(0, 44, ScreenW, ScreenH-44) backColor:kWhiteColor];
    UILabel *discribLabel = [UILabel lh_labelWithFrame:CGRectMake(0, 0, ScreenW, 100) text:@"" textColor:APP_purple_Color font:BoldFONT(25) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    UIButton *backBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, CGRectGetMaxY(discribLabel.frame)+30, ScreenW - 60, 40) target:self action:@selector(backAction) image:nil title:@"返回" titleColor:kWhiteColor font:FONT(14)];
    backBtn.backgroundColor = APP_COMMON_COLOR;
    [backBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.view addSubview:emptyView];
    [emptyView addSubview:discribLabel];
    [emptyView addSubview:backBtn];
    
    if ([self.status isEqualToString:@"0"]) {
        emptyView.hidden = YES;
    }else if ([self.status isEqualToString:@"1"]) {
        emptyView.hidden = NO;
        discribLabel.text = @"待审核！";
    }else if ([self.status isEqualToString:@"2"]){
        emptyView.hidden = NO;
        discribLabel.text = @"您已经是实名制用户！";
    }
    
}
- (void)backAction{
    
    [self.navigationController popVC];
}
- (void)finishAction{
    
    HHTextfieldcell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *nameStr = nameCell.inputTextField.text;
    HHTextfieldcell *idCardCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *idCardStr = idCardCell.inputTextField.text;
    
    NSString *validStr = [self validWithnameStr:nameStr idCardStr:idCardStr front_imgPath:self.front_imgPath back_imgPath:self.back_imgPath];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    if (!validStr) {
        [[[HHMineAPI postSpecialAuthenticationWithusername:nameStr idcard:idCardStr front_img:self.front_imgPath back_img:self.back_imgPath] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.code == 0) {
                    
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
                    //发送通知
                    POST_NOTIFY(kNotificationCertified, nil);
                    
                    [self.navigationController popVC];

                }else{
                    [SVProgressHUD showInfoWithStatus:api.msg];

                }
            }
            
        }];
    }else{
        
        [SVProgressHUD showInfoWithStatus:validStr];
    }

}
- (NSString *)validWithnameStr:(NSString *)nameStr idCardStr:(NSString *)idCardStr  front_imgPath:(NSString *)front_imgPath back_imgPath:(NSString *)back_imgPath{
    
    if (nameStr.length == 0) {
        return @"请填写姓名！";
    }else  if (idCardStr.length == 0) {
        return @"请填写身份证号！";
    }else  if (front_imgPath.length == 0) {
        return @"请选择证件照正面！";
    }
    return nil;
    
}
- (NSMutableAttributedString *)lh_attriStrWithAttrStr1:(NSString *)attrStr1 content:(NSString *)content  protocolStrColor:(UIColor *)protocolStrColor  contentColor:(UIColor *)contentColor{
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSRange attrStr1Range = [content rangeOfString:attrStr1];
    NSRange contentRange = [content rangeOfString:content];
    
    [attr addAttribute:NSFontAttributeName value:FONT(14) range:contentRange];

    [attr addAttribute:NSForegroundColorAttributeName value:contentColor range:contentRange];
    [attr addAttribute:NSForegroundColorAttributeName value:protocolStrColor range:attrStr1Range];
    
    return attr;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 3;

    }else{
        
        return 1;

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return WidthScaleSize_H(30);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return WidthScaleSize_H(0.01);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return WidthScaleSize_H(50);

    }else{
        
        return WidthScaleSize_H(170);

    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 2) {
            
            UITableViewCell *cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            NSMutableAttributedString *attrStr =  [self lh_attriStrWithAttrStr1:@"*" content:self.leftTitleArr[indexPath.row] protocolStrColor:kRedColor contentColor:kBlackColor];
             cell1.textLabel.attributedText = attrStr;
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell1;
            
        }else{
            
            HHTextfieldcell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleLabel"];
            if(!cell){
                cell = [[HHTextfieldcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.titleLabel.text = self.leftTitleArr[indexPath.row];
            cell.titleLabel.adjustsFontSizeToFitWidth = YES;
            cell.inputTextField.placeholder = self.placeholerArr[indexPath.row];
            cell.titleLabel.textColor = KTitleLabelColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 1) {
                cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
                cell.inputTextField.delegate = self;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
        
    }else{
        //
        HHidentityCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"HHidentityCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.front_imgV.userInteractionEnabled = YES;
        [cell.front_imgV setTapActionWithBlock:^{
         
            [self upLoadImagWithType:1];
        }];
        cell.back_imgV.userInteractionEnabled = YES;
        [cell.back_imgV setTapActionWithBlock:^{
            [self upLoadImagWithType:2];
            
        }];
        
        return cell;
        
    }
    
  
    return nil;
}
- (void)upLoadImagWithType:(NSInteger)type{
    
        HXTakePhotosHandle *manager =  [HXTakePhotosHandle shareManager];
        manager.vc = self;
        [manager showPhotoSheetActionWithFinishSelectedBlock:^(UIImage *image) {
            
            //
            NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
            
            MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.bezelView.color = KA0LabelColor;
            hud.detailsLabel.text = @"照片正在上传中...";
            hud.detailsLabel.textColor = kWhiteColor;
            hud.detailsLabel.font= FONT(14);
            hud.activityIndicatorColor = kWhiteColor;
            [hud showAnimated:YES];
            
        [[[HHMineAPI UploadCertificateWithImageData:imgData] netWorkClient] uploadFileInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
                if (!error) {
                    if (api.code == 0) {
                        
                       if (type == 1) {
                        HHidentityCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                        cell.front_imgV.image = image;
                        self.front_imgPath = api.data;
                        [hud hideAnimated:YES];
                       }else{
                           HHidentityCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                           cell.back_imgV.image = image;
                           self.back_imgPath = api.data;
                           [hud hideAnimated:YES];

                       }
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"照片上传失败！"];
                        [hud hideAnimated:YES];

                    }
                }
                
            }];
            
            
        }];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSString *text;
    UILabel *lab = [UILabel lh_labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) text:@"请慎重！每个账户只可校验两次" textColor:kRedColor font:FONT(12) textAlignment:NSTextAlignmentCenter backgroundColor:KVCBackGroundColor];

    if (section == 0) {
        text = @"请慎重！每个账户只可校验两次";
    }else{
        text = @"所传照片必须真实清晰才能审核通过";
    }
    
    lab.text = text;
    
    return lab;

}
@end
