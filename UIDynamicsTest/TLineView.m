//
//  TLineView.m
//  UIDynamicsTest
//
//  Created by Radoslaw Szeja on 04.01.2014.
//  Copyright (c) 2014 test. All rights reserved.
//

#import "TLineView.h"

@implementation TLineView

@synthesize start;
@synthesize end;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CGPathMoveToPoint(pathRef, NULL, start.x, start.y);
    CGPathAddLineToPoint(pathRef, NULL, end.x, end.y);
    
    CGContextAddPath(context, pathRef);
    CGContextStrokePath(context);
    CGPathRelease(pathRef);
    
    [super drawRect:rect];
}

@end
