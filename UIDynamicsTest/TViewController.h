//
//  TViewController.h
//  UIDynamicsTest
//
//  Created by Radoslaw Szeja on 03.01.2014.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLineView.h"

@interface TViewController : UIViewController
@property (nonatomic) CGPoint location;
@property (strong, nonatomic) TLineView *lineView;
@property (strong, nonatomic) UIView *boxView;
@property (strong, nonatomic) UIView *smallerBoxView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;
@end
