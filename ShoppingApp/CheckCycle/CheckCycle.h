//
//  CheckCycle.h
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/13.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckCycle;

@protocol CheckCycleDelegate <NSObject>
@optional
- (void)checkCycle:(CheckCycle *)c wasClicked:(BOOL)selected;
@end



@interface CheckCycle : UIImageView

@property(weak, nonatomic) id<CheckCycleDelegate> delegate;
@property(assign, nonatomic, getter=isSelected) BOOL selected;

- (void)setSelectedWithoutCallback:(BOOL)selected;

@end
