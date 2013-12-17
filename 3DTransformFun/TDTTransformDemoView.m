//
//  TDTTransformDemoView.m
//  3DTransformFun
//
//  Created by Vertical Turtle on 11/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import "TDTTransformDemoView.h"

@interface TDTTransformDemoView ()
@property(nonatomic, strong) CATransformLayer *transformLayer;
@property (nonatomic, strong) CALayer *gridLayer;
@property (nonatomic, strong) CALayer *anchorPointIndicator;
@end

const CGSize gridSize = (CGSize){.width = 600.0, .height = 600.0};

@implementation TDTTransformDemoView

- (id)initWithFrame:(CGRect)frame
{
    frame.size = gridSize;
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self commonSetup];
    }

    return self;
}


-(void)commonSetup
{
    CATransformLayer *transformLayer = [CATransformLayer layer];
    [self.layer addSublayer:transformLayer];
    self.transformLayer = transformLayer;
    CATransform3D sublayerTransform = CATransform3DIdentity;
    sublayerTransform.m34 = -1.0 / gridSize.width;
    self.layer.sublayerTransform = sublayerTransform;

    CALayer *gridLayer = [CALayer layer];
    gridLayer.contents = (__bridge id)[self gridContentsImage].CGImage;
    [transformLayer addSublayer:gridLayer];
    self.gridLayer = gridLayer;
    gridLayer.frame = (CGRect){.size = gridSize};

    CAShapeLayer *anchorPointIndicator = [CAShapeLayer layer];
    anchorPointIndicator.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-5.0,-5.0,10.0,10.0)].CGPath;
    anchorPointIndicator.fillColor = [UIColor redColor].CGColor;
    [transformLayer addSublayer:anchorPointIndicator];
    self.anchorPointIndicator = anchorPointIndicator;
}

-(void)setFrame:(CGRect)frame
{
    frame.size = gridSize;
    [super setFrame:frame];
}

-(void)setGridAnchorPoint:(CGPoint)anchorPoint z:(CGFloat)anchorPointZ
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CATransform3D currentTransform = self.gridLayer.transform;
    self.gridLayer.transform = CATransform3DIdentity;
    self.gridLayer.anchorPoint = anchorPoint;
    self.gridLayer.anchorPointZ = anchorPointZ;
    CGFloat newX = gridSize.width * anchorPoint.x;
    CGFloat newY = gridSize.height * anchorPoint.y;

    self.gridLayer.position = CGPointMake(newX, newY);
    self.gridLayer.transform = currentTransform;
    [CATransaction commit];
}


- (UIImage *)gridContentsImage
{
    CGRect drawingRect = (CGRect){.size= gridSize};
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, YES, 0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [[UIColor blackColor] set];
    UIRectFill(drawingRect);
    [[UIColor whiteColor] set];
    
    // Labels
    UIFont *labelFont = [UIFont boldSystemFontOfSize:50];
    [@"TOP" drawInRect:CGRectMake(0.0, 0.0, gridSize.width, 50.0) withFont:labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    CGContextTranslateCTM(c, 300, 300);
    CGContextRotateCTM(c, M_PI_2);
    CGContextTranslateCTM(c, -300, -300);
    [@"RIGHT" drawInRect:CGRectMake(0.0, 0.0, gridSize.width, 50.0) withFont:labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    CGContextTranslateCTM(c, 300, 300);
    CGContextRotateCTM(c, M_PI_2);
    CGContextTranslateCTM(c, -300, -300);
    [@"BOTTOM" drawInRect:CGRectMake(0.0, 0.0, gridSize.width, 50.0) withFont:labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    CGContextTranslateCTM(c, 300, 300);
    CGContextRotateCTM(c, M_PI_2);
    CGContextTranslateCTM(c, -300, -300);
    [@"LEFT" drawInRect:CGRectMake(0.0, 0.0, gridSize.width, 50.0) withFont:labelFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    
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

    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

@end
