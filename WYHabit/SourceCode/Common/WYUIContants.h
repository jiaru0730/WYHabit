//
//  WYUIContants.h
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#define UI_SCREEN_WIDTH             ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT            ([[UIScreen mainScreen] bounds].size.height)

#pragma mark - Color

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0xFF))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0xFF))/255.0 \
alpha:(alphaValue)]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define UI_COLOR_TINT_GREEN UIColorFromRGB(0x638e22)
#define UI_COLOR_ORANGE     [UIColor orangeColor]


#define kAnimationDurationShort 0.1f
