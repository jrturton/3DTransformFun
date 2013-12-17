//
//  TDTTransformEditorViewController.h
//  3DTransformFun
//
//  Created by Vertical Turtle on 14/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDTransform.h"

@protocol TransformEditorDelegate <NSObject>

-(void)transformEditorUpdatedTransform:(TDTransform *)transform requiresStackUpdate:(BOOL)requiresStackUpdate;

@end

@interface TDTTransformEditorViewController : UITableViewController

@property (nonatomic,strong) TDTransform* transform;
@property (nonatomic,assign) id<TransformEditorDelegate> delegate;

@end
