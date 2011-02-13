//
//  PresentingCustomViewsModallyViewController.m
//  PresentingCustomViewsModally
//
//  Created by Ahmet Ardal on 2/13/11.
//  Copyright 2011 LiveGO. All rights reserved.
//

#import "PresentingCustomViewsModallyViewController.h"
#import "ModalBoxView.h"


@implementation PresentingCustomViewsModallyViewController

- (IBAction) buttonPressed:(id)sender
{
    ModalBoxView *modalBoxView = [ModalBoxView modalBoxView];
    [modalBoxView showInView:self.view];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload
{
}

- (void) dealloc
{
    [super dealloc];
}

@end
