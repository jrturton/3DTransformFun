//
//  TDTTransformDemoView.h
//  3DTransformFun
//
//  Created by Vertical Turtle on 11/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDTTransformDemoView : UIView

@property (nonatomic, readonly) CALayer *gridLayer;
@property (nonatomic, readonly) CALayer *anchorPointIndicator;
-(void)setGridAnchorPoint:(CGPoint)anchorPoint z:(CGFloat)anchorPointZ;
@end
