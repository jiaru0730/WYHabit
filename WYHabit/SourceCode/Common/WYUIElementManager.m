//
//  WYUIElementManager.m
//  WYHabit
//
//  Created by Jia Ru on 3/27/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYUIElementManager.h"

@implementation WYUIElementManager

IMPLEMENT_SHARED_INSTANCE(WYUIElementManager)

- (UIButton *)createRoundButtonWithRadius:(CGFloat)radiusOfButton {
    UIButton *roundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CALayer *buttonLayer = roundButton.layer;

    roundButton.clipsToBounds = YES;
    buttonLayer.cornerRadius = radiusOfButton / 2;
    
    return roundButton;
}

@end
