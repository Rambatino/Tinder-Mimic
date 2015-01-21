//
//  IDImageView.m
//  __Interior Design__
//
//  Created by Mark Ramotowski on 12/01/2015.
//  Copyright (c) 2015 Mark Ramotowski. All rights reserved.
//

#import "IDImageStack.h"
#import "GGOverLayView.h"
#import "IDImageView.h"
#import "IDHeader.h"

#define SAFE_FUNCTION(function, ...) if (function) function(__VA_ARGS__);

@interface IDImageStack ()

// pan gesture recogniser
@property UIPanGestureRecognizer * panGesture;

// the tap gesture recogniser
@property UITapGestureRecognizer * tapGesture;

// recording the original point
@property CGPoint originalPoint;

@property GGOverlayView * overlayView;

// Image stack
@property NSMutableArray * imageStack;

@property int topStackTag;

@end

CGFloat pictureOffset = 5.f;

@implementation IDImageStack

- (id) initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        
        
    } return self;
    
}

// set up
- (void) awakeFromNib {
    
    self.layer.shadowOffset = CGSizeMake(.5f, .5f);
    self.layer.shadowOpacity = 0.8f;
    self.layer.cornerRadius = 0.f;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    // set up the image stack
    if (!_imageStack) {
        
        _imageStack = [NSMutableArray new];
        
        // add the four views to the array
        for ( int i = 0; i < 4; ++i ) {
            
            IDImageView *image = [IDImageView new];
            
            // need a record to which image is which
            image.tag = i;
            
            [_imageStack addObject:image];
            
        }
        
    }
    
    // set the top most image to have the properties
    [self setManipulationPropertiesOnImageWithTag:0];
}

- (void)dealloc {
    [self removeGestureRecognizer:_panGesture];
}

- (void) drawRect:(CGRect)rect {
    
    [_imageStack[0] setFrame: CGRectShiftDown_tinderMechanic(self.bounds, 0.f)];
    
    _overlayView.frame = CGRectShiftDown_tinderMechanic(self.bounds, 0.f);
    
    for ( int i = 0; i < 4; ++i ) {
        
        [_imageStack[i] setFrame: CGRectShiftDown_tinderMechanic(self.bounds, MIN(pictureOffset * i, 2 * pictureOffset))];
        
        [_imageStack[i] setImage: [_delegate nextImageForStack:self]];
        
        [self addSubview:_imageStack[i]];
        [self sendSubviewToBack:_imageStack[i]];
        
    }
    
}

// method handlers

- (void) rightShiftTopStackWithCompletion:(void (^) ()) completion {
    
    // bang the image on, and smack it off right
    [self removeImage:_imageStack[_topStackTag] love:1 withCompletion:^{
        
        SAFE_FUNCTION(completion);

        
    }];
}

- (void) leftShiftTopStackWithCompletion:(void (^) ()) completion {
    
    // bang this image off and smack it off left
    [self removeImage:_imageStack[_topStackTag] love:-1 withCompletion:^{
        
        SAFE_FUNCTION(completion);
        
    }];

}

- (void) removeImage:(IDImageView*) image love:(int) love withCompletion:(void (^) ()) completion {
    
    // move the image off of the screen
    [UIView animateWithDuration:0.4f
                     animations:^{
                         
                         CGPoint currentCentre = image.center;

                         // move off of the screen
                         currentCentre.x += love * 500.f;
                         
                         // add rotation
                         CGFloat rotationAngle = (CGFloat) (2*M_PI * love / 16);
                         
                         CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);

                         image.transform = transform;
                         
                         image.center = currentCentre;
                         
                         // pull the substack to the top
                         [self updateSubstack:MAXFLOAT withSubsequentTag:_topStackTag];
                         
                     } completion:^(BOOL finished) {
                         
                         // readd the border
                         [image resetBorder];
                         
                         // reset the substack and return all rotation
                         image.transform = CGAffineTransformMakeRotation(0.f);
                         
                         // move that image to the bottom of the stack
                         image.frame = CGRectShiftDown_tinderMechanic(self.bounds, 2 * pictureOffset);
                         
                         [self sendSubviewToBack:image];
                         
                         // change the gesture recogniser and overlay
                         int currentTag = image.tag;
                         
                         // increment tag by one to get next image
                         if ( ++currentTag == 4) currentTag = 0;
                         
                         [self setManipulationPropertiesOnImageWithTag:currentTag];
                         
                         SAFE_FUNCTION(completion);
                         
                     }];
}

- (void) dragged:(UIPanGestureRecognizer *)gestureRecognizer {
   
    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self].y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            _originalPoint = gestureRecognizer.view.center;
            break;
        };
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(xDistance / 320, 1);
            CGFloat rotationAngle = (CGFloat) (2*M_PI * rotationStrength / 16);
            CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            gestureRecognizer.view.center = CGPointMake(_originalPoint.x + xDistance, _originalPoint.y + yDistance);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            gestureRecognizer.view.transform = scaleTransform;
            
            [(IDImageView*)gestureRecognizer.view removeBorder];
            
            [self updateOverlay:xDistance];

            
            
            // logic to bring the view behind it up
            [self updateSubstack:xDistance withSubsequentTag:gestureRecognizer.view.tag];
            
            break;
        };
        case UIGestureRecognizerStateEnded: {
            
            // if the view is past a certain point, don't reset it; setting it to just passed over a quarter
            
            // take the position of the current centre of the image and subtract the point of fixation; then mod
            if (gestureRecognizer.view.center.x > 0.85f * self.frame.size.width ||
                gestureRecognizer.view.center.x < 0.15f * self.frame.size.width) {

                // move the image off of the screen
                [UIView animateWithDuration:0.2f
                                 animations:^{
                                     
                                     CGRect currentFrame = gestureRecognizer.view.frame;
                                     if (gestureRecognizer.view.center.x > 0.85f * self.frame.size.width) {
                                         currentFrame.origin.x = self.frame.size.width * 1.5f;
                                     } else currentFrame.origin.x = self.frame.size.width * -1.5f;
                                     gestureRecognizer.view.frame = currentFrame;
                                     
                                     // pull the substack to the top
                                     [self updateSubstack:MAXFLOAT withSubsequentTag:gestureRecognizer.view.tag];
                                     
                                 } completion:^(BOOL finished) {
                                     
                                     // readd the border
                                     [(IDImageView*)gestureRecognizer.view resetBorder];

                                     // reset the substack and return all rotation
                                     gestureRecognizer.view.transform = CGAffineTransformMakeRotation(0.f);
                                     
                                     // move that image to the bottom of the stack
                                     gestureRecognizer.view.frame = CGRectShiftDown_tinderMechanic(self.bounds, 2 * pictureOffset);
                                     
                                     [self sendSubviewToBack:gestureRecognizer.view];
                                     
                                     // change the gesture recogniser and overlay
                                     int currentTag = gestureRecognizer.view.tag;
                                     
                                     // increment tag by one to get next image
                                     if ( ++currentTag == 4) currentTag = 0;
                                     
                                     [self setManipulationPropertiesOnImageWithTag:currentTag];
                                     
                                     // inform the delegate that the image has shifted position
                                     if ([_delegate respondsToSelector:@selector(stack:wasSlidWithDirection:withImage:)]) {
                                         
                                         IDImageStackSwipeDirection direction;
                                         
                                         // get the direction
                                         if (gestureRecognizer.view.center.x > 0.85f * self.frame.size.width) {
                                             
                                             direction = IDImageStackSwipeRight;
                                             
                                         } else {
                                             
                                             direction = IDImageStackSwipeLeft;
                                             
                                         }
                                         
                                         IDImageView *imageView = _imageStack[gestureRecognizer.view.tag];
                                         
                                         [_delegate stack:self wasSlidWithDirection:direction withImage:imageView.image];
                                         
                                     }
                                 }];
            
            } else {
                // else reset view
                [self resetViewPositionAndTransformations:(IDImageView*)gestureRecognizer.view];
                
            }
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
    
}

- (void) tapped:(UITapGestureRecognizer *) gesture {
    
    if ([_delegate respondsToSelector:@selector(stack:wasPressedWithCurrentImage:)]) {

        IDImageView * topImage = _imageStack[_topStackTag];
        
        [_delegate stack:self wasPressedWithCurrentImage:topImage.image];
    
    }
    
}

- (void) setManipulationPropertiesOnImageWithTag:(int) tag {
    
    // need to add overlay to the first view only, then subsequently switch it to other views
    if (!_overlayView)
        _overlayView = [GGOverlayView new];
    
    _overlayView.alpha = 0;
    
    [_imageStack[tag] addSubview:_overlayView];
    
    // sort the pan out
    if (!_panGesture)
    _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragged:)];
    
    [_imageStack[tag] addGestureRecognizer:_panGesture];
    
    if (!_tapGesture)
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    
    [_imageStack[tag] addGestureRecognizer:_tapGesture];
    
    _topStackTag = tag;
    
}

- (void) updateSubstack:(CGFloat) distance withSubsequentTag:(int) tag {
    
    CGFloat resetDistance = MIN(fabsf(distance) / 60, pictureOffset);
    
    if (++tag == 4) tag = 0;
    
    [_imageStack[tag] setFrame:CGRectShiftDown_tinderMechanic(self.bounds, pictureOffset - resetDistance)];
    
    if (++tag == 4) tag = 0;

    [_imageStack[tag] setFrame:CGRectShiftDown_tinderMechanic(self.bounds, 2 * pictureOffset - resetDistance)];

}

- (void)resetViewPositionAndTransformations:(IDImageView*) view {
    [UIView animateWithDuration:0.2
                     animations:^{
                         view.center = self.originalPoint;
                         [view resetBorder];
                         view.transform = CGAffineTransformMakeRotation(0);
                         _overlayView.alpha = 0.f;
                         
                         [self updateSubstack:MAXFLOAT withSubsequentTag:view.tag-1];
                         
                     }];
}

- (void)updateOverlay:(CGFloat)distance {
    if (distance > 50 || distance <= -50) {
        
        if (distance > 0) {
            
            _overlayView.mode = GGOverlayViewModeRight;
            
        } else if (distance <= 0) {
            
            _overlayView.mode = GGOverlayViewModeLeft;
            
        }
        
        CGFloat overlayStrength = MIN((fabsf(distance) - 50.f) / 100.f, 0.4f);
        
        _overlayView.alpha = overlayStrength;
    }
}

// accessing the current images in order
- (NSMutableArray*) currentStackValues {
    
    __block  NSMutableArray * new = [NSMutableArray new];
    
    [_imageStack enumerateObjectsUsingBlock:^(IDImageView * obj, NSUInteger idx, BOOL *stop) {
       
        [new addObject:obj.image];
        
    }];
    
    return new;
}

@end
