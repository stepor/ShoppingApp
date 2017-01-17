//
//  HTTPSessionManager.m
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/30.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import "HTTPSessionManager.h"

@implementation HTTPSessionManager

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static HTTPSessionManager *manager = NULL;
    dispatch_once(&onceToken, ^{
        manager = [HTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return manager;
}

@end
