//
//  TDTTransformTypeViewController.h
//  3DTransformFun
//
//  Created by Vertical Turtle on 13/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDTransform.h"

@class TDTTransformTypeViewController;

@protocol TransformTypeDelegate <NSObject>

-(void)transformTypeSelected:(TransformType)transformType;

@end

@interface TDTTransformTypeViewController : UITableViewController

@property (nonatomic) TransformType transformType;
@property (nonatomic,assign) id<TransformTypeDelegate> delegate;

@end
