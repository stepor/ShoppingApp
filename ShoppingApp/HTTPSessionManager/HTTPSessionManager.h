//
//  HTTPSessionManager.h
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/30.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

@end
