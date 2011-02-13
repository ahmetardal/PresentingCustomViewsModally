//
//  ModalBoxView.h
//  PresentingCustomViewsModally
//
//  Created by Ahmet Ardal on 2/13/11.
//  Copyright 2011 LiveGO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalBoxView: UIView
{
    UIView *overlayView;
    UIView *modalBoxView;
    BOOL _isVisible;
}

@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIView *modalBoxView;

+ (ModalBoxView *) modalBoxView;

- (void) showInView:(UIView *)parentView;
- (void) hide;

@end
