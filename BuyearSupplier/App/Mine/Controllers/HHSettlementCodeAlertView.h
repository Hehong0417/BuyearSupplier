//
//  HHSettlementCodeAlertView.h
//  Store
//
//  Created by User on 2018/1/11.
//  Copyright © 2018年 User. All rights reserved.
//

#import "LHAlertView.h"
#import "HHSettlementCodeView.h"

@interface HHSettlementCodeAlertView : LHAlertView
{
    HHSettlementCodeView *CodeView;
}
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *settlementCode;

@end
