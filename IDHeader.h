//
//  IDHeader.h
//  __Interior Design__
//
//  Created by Mark Ramotowski on 15/01/2015.
//  Copyright (c) 2015 Mark Ramotowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Expanded.h"

extern NSString *const kBackgroundColourThemeHex;
extern NSString *const kButtonColourThemeHex;
extern const CGFloat kGlobalCornerRadius;
extern const CGFloat kTabBarHeight;

extern CGRect CGRectShiftDown(CGRect rect, CGFloat dx);
extern CGRect CGRectShiftYTo(CGRect rect, CGFloat dy);
extern CGRect kStatusBar();
extern CGRect CGRectShiftDown_tinderMechanic(CGRect rect, CGFloat dx);