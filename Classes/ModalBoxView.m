//
//  ModalBoxView.m
//  PresentingCustomViewsModally
//
//  Created by Ahmet Ardal on 2/13/11.
//  Copyright 2011 LiveGO. All rights reserved.
//

#import "ModalBoxView.h"


//
// modal box size constants
//
static const CGFloat kModalBoxWidth   = 288.0f;
static const CGFloat kModalBoxHeight  = 188.0f;
static const CGFloat kModalBoxPadding = 15.0f;

//
// animation context constants
//
#define kShowContext    1
#define kHideContext    2


@interface ModalBoxView(Private)
- (IBAction) buttonPressed:(id)sender;
- (void) interfaceOrientationWillChange:(NSNotification *)notification;
- (CGRect) viewFrameForOrientation:(UIInterfaceOrientation)orientation;
- (BOOL) shouldModifyLayoutForOrientation:(UIInterfaceOrientation)orientation;
@end


@implementation ModalBoxView

@synthesize overlayView, modalBoxView;

- (id) init
{
    if (!(self = [super initWithFrame:CGRectZero])) {
        return self;
    }

    //
    // initialization
    //
    _isVisible = NO;
    self.alpha = 0.0f;
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.userInteractionEnabled = YES;

    //
    // create background overlay view
    //
    UIView *_overlayView = [[UIView alloc] initWithFrame:CGRectZero];
    _overlayView.alpha = 0.6f;
    _overlayView.backgroundColor = [UIColor blackColor];
    _overlayView.opaque = NO;
    [self addSubview:_overlayView];
    self.overlayView = _overlayView;
    [_overlayView release];

    //
    // create modal box view
    //
    UIView *_modalBoxView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kModalBoxWidth, kModalBoxHeight)];
    _modalBoxView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | 
                                     UIViewAutoresizingFlexibleTopMargin  | UIViewAutoresizingFlexibleBottomMargin;
    _modalBoxView.backgroundColor = [UIColor clearColor];
    _modalBoxView.opaque = NO;
    [self addSubview:_modalBoxView];
    self.modalBoxView = _modalBoxView;
    [_modalBoxView release];

    //
    // create modal box background imageview
    //
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:_modalBoxView.frame];
    bgImgView.image = [UIImage imageNamed:@"modalbox_bg"];
    bgImgView.alpha = 0.75f;
    bgImgView.backgroundColor = [UIColor clearColor];
    bgImgView.opaque = NO;
    [_modalBoxView addSubview:bgImgView];
    [bgImgView release];
    
    //
    // create modal box text label
    //
    CGFloat labelWidth = kModalBoxWidth - (kModalBoxPadding * 2);
    CGRect labelFrame = CGRectMake(kModalBoxPadding, kModalBoxPadding, labelWidth, 105.0f);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    //label.textAlignment = UITextAlignmentCenter;
    label.numberOfLines = 5;
    label.text = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                 @"Lorem Ipsum has been the industry's standard dummy text ever.";
    [_modalBoxView addSubview:label];
    [label release];

    //
    // create modal box button
    //
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat buttonPosY = label.frame.size.height + (kModalBoxPadding * 2);
    CGRect buttonFrame = CGRectMake(kModalBoxPadding, buttonPosY, labelWidth, 37.0f);
    button.frame = buttonFrame;
    [button setTitle:@"okay, now close me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_modalBoxView addSubview:button];
    
    //
    // register for interface orientation change notifications
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(interfaceOrientationWillChange:)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];

    return self;
}

+ (ModalBoxView *) modalBoxView
{
    return [[[ModalBoxView alloc] init] autorelease];
}

- (void) dealloc
{
    NSLog(@"ModalBoxView::dealloc called");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.overlayView release];
    [self.modalBoxView release];
    [super dealloc];
}


#pragma mark -
#pragma mark 

- (void) showInView:(UIView *)parentView
{
    if (_isVisible) {
        return;
    }

    //
    // adjust frames for self, overlayview and modalboxview
    //
    self.frame = [self viewFrameForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    self.overlayView.frame = self.frame;
    self.modalBoxView.center = self.overlayView.center;
    [parentView addSubview:self];
    [self setNeedsLayout];

    //
    // show view with animation
    //
    [UIView beginAnimations:nil context:(void *) kShowContext];
    [UIView setAnimationDuration:0.2f];
    self.alpha = 1.0f;
    [UIView commitAnimations];

    _isVisible = YES;
}

- (void) hide
{
    if (!_isVisible) {
        return;
    }

    //
    // hide view with animation
    //
    [UIView beginAnimations:nil context:(void *) kHideContext];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2f];
    self.alpha = 0.0f;
    [UIView commitAnimations];

    _isVisible = NO;
}

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if (((int) context) == kHideContext) {
        //
        // hide animation finished, we can remove self from our superview
        //
        [self removeFromSuperview];
    }
}


#pragma mark -
#pragma mark Private Methods

- (IBAction) buttonPressed:(id)sender
{
    NSLog(@"ModalBoxView::buttonPressed called");
    [self hide];
}

- (void) interfaceOrientationWillChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    UIInterfaceOrientation newInterfaceOrientation =
        (UIInterfaceOrientation) [[userInfo objectForKey:UIApplicationStatusBarOrientationUserInfoKey] unsignedIntegerValue];

    //
    // adjust views for interface orientation change, if necessary
    //
    if ([self shouldModifyLayoutForOrientation:newInterfaceOrientation]) {
        self.frame = [self viewFrameForOrientation:newInterfaceOrientation];
        self.overlayView.frame = self.frame;
        self.modalBoxView.center = self.overlayView.center;
        [self setNeedsLayout];
    }
}

- (CGRect) viewFrameForOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
    }
    else {
        return CGRectMake(0.0f, 0.0f, 480.0f, 300.0f);
    }
}

- (BOOL) shouldModifyLayoutForOrientation:(UIInterfaceOrientation)orientation
{
    //
    // check whether the "orientation" and current interface orientation are same or not
    //
    return (UIInterfaceOrientationIsLandscape(orientation) && (self.frame.size.width < 480.0f)) ||
           (UIInterfaceOrientationIsPortrait(orientation)  && (self.frame.size.width > 320.0f));
}

@end
