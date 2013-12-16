//
//  TDTTransformDemoView.m
//  3DTransformFun
//
//  Created by Vertical Turtle on 11/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import "TDTTransformDemoView.h"

@implementation TDTTransformDemoView

- (id)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(600, 600);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    frame.size = CGSizeMake(600.0, 600.0);
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect
{
    // We're always 600 x 600, get over it.
    
    CGRect drawingRect = self.bounds;
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [[UIColor blackColor] set];
    UIRectFill(drawingRect);
    [[UIColor whiteColor] set];
    
    // Labels
    UIFont *labelFont = [UIFont boldSystemFontOfSize:50];
    [@"TOP" drawInRect:CGRectMake(0.0, 0.0, 600.0, 50.0) withFont:labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    CGContextTranslateCTM(c, 300, 300);
    CGContextRotateCTM(c, M_PI_2);
    CGContextTranslateCTM(c, -300, -300);
    [@"RIGHT" drawInRect:CGRectMake(0.0, 0.0, 600.0, 50.0) withFont:labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    CGContextTranslateCTM(c, 300, 300);
    CGContextRotateCTM(c, M_PI_2);
    CGContextTranslateCTM(c, -300, -300);
    [@"BOTTOM" drawInRect:CGRectMake(0.0, 0.0, 600.0, 50.0) withFont:labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    CGContextTranslateCTM(c, 300, 300);
    CGContextRotateCTM(c, M_PI_2);
    CGContextTranslateCTM(c, -300, -300);
    [@"LEFT" drawInRect:CGRectMake(0.0, 0.0, 600.0, 50.0) withFont:labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    
    CGContextSetLineWidth(c, 2.0);
    CGRect gridRect = CGRectInset(drawingRect,50,50);

    for (int i = 0;i < 10; i++)
    {
        CGContextStrokeRect(c, gridRect);
        gridRect = CGRectInset(gridRect, 50, 0);
    }
    gridRect = CGRectInset(drawingRect,50,50);
    
    for (int i = 0;i < 10; i++)
    {
        CGContextStrokeRect(c, gridRect);
        gridRect = CGRectInset(gridRect, 0, 50);
    }
    
    
    
}

@end
