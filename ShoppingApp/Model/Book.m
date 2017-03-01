//
//  Book.m
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/31.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import "Book.h"

@implementation Book

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"titleSummary" : @"sub1", @"contentSummary" : @"sub2", @"imgUrlString" : @"img", @"readingQuantity" : @"reading", @"onlineShoppingAddress" : @"online", @"publishingTime" : @"bytime"};
}

- (void)duplicateAllPropertyToPurchasedBook:(PurchasedBook *)pBook {
    NSAssert(pBook, @"pBook in %s can not be nil!", __func__);
   
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for(unsigned int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = 	ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        if([key characterAtIndex:0] == '_') {
            key = [key substringFromIndex:1];
        }
        id value = [self valueForKey:key];
        if(value) {
            [pBook setValue:value forKey:key];
        }
    }
}
@end
