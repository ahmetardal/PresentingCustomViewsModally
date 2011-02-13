//
//  PresentingCustomViewsModallyAppDelegate.h
//  PresentingCustomViewsModally
//
//  Created by Ahmet Ardal on 2/13/11.
//  Copyright 2011 LiveGO. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PresentingCustomViewsModallyViewController;

@interface PresentingCustomViewsModallyAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PresentingCustomViewsModallyViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PresentingCustomViewsModallyViewController *viewController;

@end

