//
//  TDTransform.m
//  3DTransformFun
//
//  Created by Vertical Turtle on 13/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import "TDTransform.h"

@implementation TDTransform

#pragma mark - Class methods

+(TDTransform*)transform
{
    TDTransform *newTransform = [[self alloc] init];
    newTransform.type = TransformTypeRotation;
    return newTransform;
}

+(NSArray*)transformTypeNames
{
    return @[@"Rotation",@"Scale",@"Translation",@"Manual"];
}
+(NSString*)nameForTransformType:(TransformType)transformType
{
    return [[self transformTypeNames] objectAtIndex:transformType];
}

#pragma mark - Accessors

-(void)setType:(TransformType)type
{
    _type = type;
    _transform = CATransform3DIdentity;
    NSArray *components;
    switch (type)
    {
        case TransformTypeManual:
            components = @[
            @[@"1",@"0",@"0",@"0"],
            @[@"0",@"1",@"0",@"0"],
            @[@"0",@"0",@"1",@"0"],
            @[@"0",@"0",@"0",@"1"]
            ];
            break;
        case TransformTypeRotation:
            components = @[
            @[@"0"],
            @[@"1",@"0",@"0"]
            ];
            break;
        case TransformTypeScale:
            components = @[@[@"1",@"1",@"1"]];
            break;
        case TransformTypeTranslation:
            components = @[@[@"0",@"0",@"0"]];
            break;
    }
    self.components = [components mutableCopy];
}

-(void)updateTransform
{
    switch (self.type)
    {
        case TransformTypeManual:{
            CATransform3D transform = CATransform3DIdentity;
            transform.m11 = [self.components[0][0] floatValue];
            transform.m12 = [self.components[0][1] floatValue];
            transform.m13 = [self.components[0][2] floatValue];
            transform.m14 = [self.components[0][3] floatValue];
            transform.m21 = [self.components[1][0] floatValue];
            transform.m22 = [self.components[1][1] floatValue];
            transform.m23 = [self.components[1][2] floatValue];
            transform.m24 = [self.components[1][3] floatValue];
            transform.m31 = [self.components[2][0] floatValue];
            transform.m32 = [self.components[2][1] floatValue];
            transform.m33 = [self.components[2][2] floatValue];
            transform.m34 = [self.components[2][3] floatValue];
            transform.m41 = [self.components[3][0] floatValue];
            transform.m42 = [self.components[3][1] floatValue];
            transform.m43 = [self.components[3][2] floatValue];
            transform.m44 = [self.components[3][3] floatValue];
            self.transform = transform;
            break;
        }
        case TransformTypeRotation:{
            CGFloat rotation = [self.components[0][0] floatValue];
            CGFloat xVector = [self.components[1][0] floatValue];
            CGFloat yVector = [self.components[1][1] floatValue];
            CGFloat zVector = [self.components[1][2] floatValue];
            self.transform = CATransform3DMakeRotation(rotation, xVector, yVector, zVector);
            break;
        }
        case TransformTypeScale:{
            CGFloat xScale = [self.components[0][0] floatValue];
            CGFloat yScale = [self.components[0][1] floatValue];
            CGFloat zScale = [self.components[0][2] floatValue];
            self.transform = CATransform3DMakeScale(xScale, yScale, zScale);
            break;
        }
        case TransformTypeTranslation:{
            CGFloat xTrans = [self.components[0][0] floatValue];
            CGFloat yTrans = [self.components[0][1] floatValue];
            CGFloat zTrans = [self.components[0][2] floatValue];
            self.transform = CATransform3DMakeTranslation(xTrans, yTrans, zTrans);
            break;            
        }
    }
}
@end
