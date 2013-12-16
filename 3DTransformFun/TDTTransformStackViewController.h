//
//  TDTTransformStackViewController.h
//  3DTransformFun
//
//  Created by Vertical Turtle on 13/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDTransform.h"

@class TDTTransformStackViewController;

@protocol TransformStackDelegate <NSObject>

-(void)transformStackChangedData:(TDTTransformStackViewController*)stack;
-(void)transformStack:(TDTTransformStackViewController*)stack selectedTransform:(TDTransform*)transform;

@end

@interface TDTTransformStackViewController : UITableViewController

-(void)addTransform:(TDTransform*)transform;
-(void)updatedTransform:(TDTransform*)transform;

-(CATransform3D)allTransforms;
@property (nonatomic,assign) id<TransformStackDelegate> delegate;

@end
