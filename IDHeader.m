//
//  IDHeader.m
//  __Interior Design__
//
//  Created by Mark Ramotowski on 15/01/2015.
//  Copyright (c) 2015 Mark Ramotowski. All rights reserved.
//

#import "IDHeader.h"

NSString *const kBackgroundColourThemeHex = @"6C7A89";
NSString *const kButtonColourThemeHex = @"FF8A81";
const CGFloat kGlobalCornerRadius = 7.f;
const CGFloat kTabBarHeight = 52.f;

CGRect CGRectShiftYTo(CGRect rect, CGFloat dy) {
    
    CGRect newRect = rect;
    newRect.origin.y = dy;
    
    return newRect;
    
}

CGRect kStatusBar() {
    
    return [UIApplication sharedApplication].statusBarFrame;
}

// image stack mechanics
CGRect CGRectShiftDown_tinderMechanic(CGRect rect, CGFloat dx) {
    
    return CGRectMake(rect.origin.x + dx, rect.origin.y + dx, rect.size.width - 2 * dx, rect.size.height);
    
}