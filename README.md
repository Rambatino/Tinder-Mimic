# Tinder-Mimic
A suite for implementing tinder-like animations

This is a really simple and easy to use set of classes that enable a highly modifiable tinder mechanic to be incorporated into your app.

The mimic involves a stack of four IDImageViews that are placed one on top of the other in the IDImageStack. To interact with the stack and its mechanics, three delegate methods are implemented:

    - (UIImage*) nextImageForStack:(IDImageStack *)stack;

    - (void) stack:(IDImageStack *)stack wasPressedWithCurrentImage:(UIImage *)image;

    - (void) stack:(IDImageStack *)stack wasSlidWithDirection:(IDImageStackSwipeDirection)direction withImage:(UIImage *)image;
    
These methods are self-explanatory: 

The nextImageForStack is required and the delegate must provide the images as requested. By tapping on the top image, the delegate method returns which image was tapped and the last method returns which image was slid.

The stack can be instantiated using storyboard, or the set up methods in -(void) awakeFromNib can be shifted to the -(id) init method for programmatically setting the stack up. 

I'd also like to thank [Nimrod Gutman](http://guti.in/articles/creating-tinder-like-animations/) for some of the initial code that i modified to create the stack. This link will also provide a useful resource for any further modifications on the classes.

Contributions and/or modifications are welcome!