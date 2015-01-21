//
//  IDImageView.h
//  __Interior Design__
//
//  Created by Mark Ramotowski on 12/01/2015.
//  Copyright (c) 2015 Mark Ramotowski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, IDImageStackSwipeDirection) {
    IDImageStackSwipeLeft,
    IDImageStackSwipeRight
};

@class IDImageStack;
@protocol IDImageStackDelegate <NSObject, UITableViewDataSource>

@optional

// tapping the top of the stack
- (void) stack:(IDImageStack *) stack wasPressedWithCurrentImage:(UIImage *) image;

// choosing the image
- (void) stack:(IDImageStack *) stack wasSlidWithDirection:(IDImageStackSwipeDirection) direction withImage:(UIImage*) image;

@required
- (UIImage *) nextImageForStack:(IDImageStack *) stack;

@end

@interface IDImageStack : UIView

@property (nonatomic, readonly) NSMutableArray * currentStackValues;

- (void) rightShiftTopStackWithCompletion:(void (^) ()) completion;

- (void) leftShiftTopStackWithCompletion:(void (^) ()) completion;

@property (weak) id<IDImageStackDelegate> delegate;

@end
