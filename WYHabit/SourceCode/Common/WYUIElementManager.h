//
//  WYUIElementManager.h
//  WYHabit
//
//  Created by Jia Ru on 3/27/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYUIElementManager : NSObject

DECLARE_SHARED_INSTANCE(WYUIElementManager)

- (UIButton *)createRoundButtonWithRadius:(CGFloat)radiusOfButton;

@end
