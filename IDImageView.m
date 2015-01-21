//
//  IDImage.m
//  __Interior Design__
//
//  Created by Mark Ramotowski on 13/01/2015.
//  Copyright (c) 2015 Mark Ramotowski. All rights reserved.
//

#import "IDImageView.h"

@implementation IDImageView

- (id) init  {
    
    if (self = [super init]) {
        
        self.layer.cornerRadius = 0.f;
        
        self.layer.masksToBounds = YES;
        
        self.userInteractionEnabled = YES;
        
        self.opaque = YES;
        
        [self resetBorder];
        
//        self.contentMode = UIViewContentModeScaleToFill;
        
    } return self;
}

- (void) removeBorder {
    
    self.layer.borderWidth = 0.f;
    
}


- (void) resetBorder {
    
    self.layer.borderColor = [UIColor colorWithWhite:0.f alpha:0.3f].CGColor;
    
    self.layer.borderWidth = .4f;
    
}


@end
