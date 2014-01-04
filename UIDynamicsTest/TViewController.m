//
//  TViewController.m
//  UIDynamicsTest
//
//  Created by Radoslaw Szeja on 03.01.2014.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "TViewController.h"

@interface TViewController ()
@property (nonatomic) BOOL boxTouchBegun;
@end

@implementation TViewController

@synthesize boxTouchBegun;
@synthesize boxView;
@synthesize smallerBoxView;
@synthesize animator;
@synthesize location;
@synthesize attachmentBehavior;
@synthesize lineView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Instantiating boxes
    boxView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    smallerBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    // Instantiating line
    lineView = [[TLineView alloc] initWithFrame:self.view.frame];
    lineView.start = smallerBoxView.center;
    lineView.end = boxView.center;
    
    [boxView setBackgroundColor:[UIColor redColor]];
    [smallerBoxView setBackgroundColor:[UIColor greenColor]];
    
    [self.view addSubview:boxView];
    [self.view addSubview:smallerBoxView];
    [self.view addSubview:lineView];
    
    // Instantiating animator
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    CGVector vector = CGVectorMake(0.0, 1.0);
    
    // Defining behaviors
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[boxView, smallerBoxView]];
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[boxView, smallerBoxView]];
    UIDynamicItemBehavior *behavior = [[UIDynamicItemBehavior alloc] initWithItems:@[boxView, smallerBoxView]];
    UIAttachmentBehavior *springAttachment = [[UIAttachmentBehavior alloc] initWithItem:smallerBoxView attachedToItem:boxView];
    
    // Setting behaviors properties
    [gravity setGravityDirection:vector];
    [collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [behavior setElasticity:0.5f];
    [springAttachment setFrequency:1.0];
    [springAttachment setDamping:0.3];
    
    // Adding behaviors
    [animator addBehavior:gravity];
    [animator addBehavior:collision];
    [animator addBehavior:behavior];
    [animator addBehavior:springAttachment];
    
    // Observing center of two boxes to redraw the connecting line
    [boxView addObserver:self forKeyPath:@"center" options:0 context:NULL];
    [smallerBoxView addObserver:self forKeyPath:@"center" options:0 context:NULL];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    location = [touch locationInView:self.view];
    
    // Touching the smallerBoxView
    if (location.x >= smallerBoxView.frame.origin.x
        && location.x <= smallerBoxView.frame.origin.x + smallerBoxView.frame.size.width
        && location.y >= smallerBoxView.frame.origin.y
        && location.y <= smallerBoxView.frame.origin.y + smallerBoxView.frame.size.height)
    {
        boxTouchBegun = YES; // dummy flag
        
        // adding attachment behavior between smallerBoxView and its center
        // so there is no effect of 'hanging'
        attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:smallerBoxView attachedToAnchor:smallerBoxView.center];
        [animator addBehavior:attachmentBehavior];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (boxTouchBegun) {
        UITouch *touch = [touches anyObject];
        location = [touch locationInView:self.view];
        attachmentBehavior.anchorPoint = location;
        [self drawLineFromPoint:smallerBoxView.center toPoint:boxView.center];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // clean up
    [animator removeBehavior:attachmentBehavior];
    attachmentBehavior = nil;
    location = CGPointZero;
    boxTouchBegun = NO;
}

- (void)drawLineFromPoint:(CGPoint)start toPoint:(CGPoint)end
{
    lineView.start = start;
    lineView.end = end;
    [lineView setNeedsDisplay]; // forces lineView to call drawRect:
}

// Handling boxes center changes
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"center"] && (object == boxView || object == smallerBoxView)) {
        [self drawLineFromPoint:smallerBoxView.center toPoint:boxView.center];
    }
}

@end
