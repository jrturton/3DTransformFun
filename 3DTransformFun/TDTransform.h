//
//  TDTransform.h
//  3DTransformFun
//
//  Created by Vertical Turtle on 13/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TransformTypeRotation,
    TransformTypeScale,
    TransformTypeTranslation,
    TransformTypeManual
} TransformType;

@interface TDTransform : NSObject

@property (nonatomic) TransformType type;
@property (nonatomic) CATransform3D transform;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSMutableArray *components;

+(TDTransform*)transform;
+(NSArray*)transformTypeNames;
+(NSString*)nameForTransformType:(TransformType)transformType;
-(void)updateTransform;

@end
