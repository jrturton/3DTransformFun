//
//  TDTTransformEditorViewController.m
//  3DTransformFun
//
//  Created by Vertical Turtle on 14/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import "TDTTransformEditorViewController.h"
#import "TransformEditorCell.h"

@interface TDTTransformEditorViewController ()

-(IBAction)stepperChanged:(UIStepper*)sender;

@end

@implementation TDTTransformEditorViewController

#pragma mark - Accessors

-(void)setTransform:(TDTransform *)transform
{
    _transform = transform;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (self.transform.type) {
        case TransformTypeManual:
            return 4;
            break;
        case TransformTypeRotation:
            return 2;
            break;
        case TransformTypeScale:
            return 1;
            break;
        case TransformTypeTranslation:
            return 1;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.transform.type) {
        case TransformTypeManual:
            return 4;
            break;
        case TransformTypeRotation:
            if (section == 0)
                return 1;
            else
                return 3;
            break;
        case TransformTypeScale:
            return 3;
            break;
        case TransformTypeTranslation:
            return 3;
            break;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (self.transform.type) {
        case TransformTypeManual:
            return [NSString stringWithFormat:@"m%d",section + 1];
            break;
        case TransformTypeRotation:
            if (section == 0)
                return @"Angle";
            else
                return @"Vector";
            break;
        case TransformTypeScale:
            return nil;
            break;
        case TransformTypeTranslation:
            return nil;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransformEditorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditorCell" forIndexPath:indexPath];
    
    static NSArray *xyz = nil;
    if (!xyz) xyz = @[@"x",@"y",@"z"];
    
    cell.stepper.stepValue = 0.1;
    switch (self.transform.type) {
        case TransformTypeManual:
            cell.name.text = [NSString stringWithFormat:@"m%d%d",indexPath.section + 1,indexPath.row + 1];
            cell.stepper.stepValue = 0.1;
            break;
        case TransformTypeRotation:
            if (indexPath.section == 0)
                cell.name.text = @"Angle (Radians)";
            else
                cell.name.text = [xyz objectAtIndex:indexPath.row];
            break;
        case TransformTypeScale:
            cell.name.text = [xyz objectAtIndex:indexPath.row];
            break;
        case TransformTypeTranslation:
            cell.name.text = [xyz objectAtIndex:indexPath.row];
            cell.stepper.stepValue = 10.0;
            cell.stepper.minimumValue = -500.0;
            cell.stepper.maximumValue = 500.0;
            break;
    }
    cell.value.text = [[self.transform.components objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.stepper.value = cell.value.text.doubleValue;
    return cell;
}

#pragma mark - Actions

-(void)stepperChanged:(UIStepper *)sender
{
    CGPoint location = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:location];
    TransformEditorCell * cell = (TransformEditorCell*)[self.tableView cellForRowAtIndexPath:path];
    cell.value.text = [NSString stringWithFormat:@"%f",sender.value];
    NSMutableArray *components = [[self.transform.components objectAtIndex:path.section] mutableCopy];
    [components replaceObjectAtIndex:path.row withObject:cell.value.text];
    [self.transform.components replaceObjectAtIndex:path.section withObject:components];
    [self.transform updateTransform];
    [self.delegate transformEditorUpdatedTransform:self.transform];
}

@end
