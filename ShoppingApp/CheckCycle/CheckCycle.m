//
//  CheckCycle.m
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/13.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import "CheckCycle.h"

@interface CheckCycle()



@end

@implementation CheckCycle
@dynamic selected;
BOOL _selected;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
   self =  [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    
    NSLog(@"checkCycle: %s", __func__);
    
    if(self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeScaleAspectFit;
    _selected = false;
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.image = [UIImage imageNamed:@"unselectedImage"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)];
    [self addGestureRecognizer:tap];
}

- (void)touchAction:(UITapGestureRecognizer *)tap {
    self.selected = !self.isSelected;
}

#pragma mark - --- accesser ---
- (void)setSelected:(BOOL)selected {
    
    if(selected) {
        self.image = [UIImage imageNamed:@"selectedImage"];
    } else {
        self.image = [UIImage imageNamed:@"unselectedImage"];
    }
    
    if([self.delegate respondsToSelector:@selector(checkCycle:wasClicked:)]) {
        [self.delegate checkCycle:self wasClicked:selected];
    }
    
    _selected = selected;
}


- (BOOL)isSelected {
    return _selected;
}


@end
