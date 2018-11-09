//
//  KeyChainManager.h
//  Store
//
//  Created by User on 2018/4/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainManager : NSObject

/**保存数据**/
+(BOOL)keyChainSaveData:(id)data withIdentifier:(NSString*)identifier;

/**读取数据**/
+(id) keyChainReadData:(NSString*)identifier;

/**更新数据**/
+(BOOL)keyChainUpdata:(id)data withIdentifier:(NSString*)identifier;

/**删除数据**/
+(void)keyChainDelete:(NSString*)identifier;

@end
