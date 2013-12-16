//
//  TransformEditorCell.h
//  3DTransformFun
//
//  Created by Vertical Turtle on 14/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransformEditorCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIStepper* stepper;
@property (nonatomic,weak) IBOutlet UILabel* value;
@property (nonatomic,weak) IBOutlet UILabel* name;
@end
