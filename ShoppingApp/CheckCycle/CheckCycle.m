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

#pragma mark - Initialization
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
    self.userInteractionEnabled = YES;
    _selected = false;
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.image = [UIImage imageNamed:@"unselectedImage"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction:)];
    [self addGestureRecognizer:tap];
}

- (void)touchAction:(UITapGestureRecognizer *)tap {
    [self setSelected:!_selected];
}

#pragma mark - Public methods
- (void)setSelectedWithoutCallback:(BOOL)selected {
    _selected = selected;
    if(selected) {
        self.image = [UIImage imageNamed:@"selectedImage"];
    } else {
        self.image = [UIImage imageNamed:@"unselectedImage"];
    }
}

#pragma mark - --- accesser ---
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if(selected) {
        self.image = [UIImage imageNamed:@"selectedImage"];
    } else {
        self.image = [UIImage imageNamed:@"unselectedImage"];
    }
    
    if([self.delegate respondsToSelector:@selector(checkCycle:wasClicked:)]) {
        NSLog(@"c: %@", self);
        [self.delegate checkCycle:self wasClicked:selected];
    }
}


- (BOOL)isSelected {
    return _selected;
}


@end
