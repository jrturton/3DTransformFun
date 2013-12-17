//
//  TDTTransformEditorViewController.m
//  3DTransformFun
//
//  Created by Vertical Turtle on 14/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import "TDTTransformEditorViewController.h"
#import "TransformEditorCell.h"
#import "TDTTransformTypeViewController.h"

@interface TDTTransformEditorViewController () <TransformTypeDelegate, UIPopoverControllerDelegate>

@property(nonatomic, strong) UIPopoverController *popover;

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
    if (!self.transform)
        return 0;

    NSInteger sections = 0;

    switch (self.transform.type) {
        case TransformTypeManual:
            sections =  4;
            break;
        case TransformTypeRotation:
            sections =  2;
            break;
        case TransformTypeScale:
            sections =  1;
            break;
        case TransformTypeTranslation:
            sections = 1;
            break;
    }

    // Always add a section for the name and type
    sections ++;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        // Name and type
        return 2;
    }

    switch (self.transform.type) {
        case TransformTypeManual:
            return 4;
        case TransformTypeRotation:
            if (section == 1)
                return 1;
            else
                return 3;
        case TransformTypeScale:
            return 3;
        case TransformTypeTranslation:
            return 3;
        default:
            return 0;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Current transform";

    switch (self.transform.type) {
        case TransformTypeManual:
            return [NSString stringWithFormat:@"m%d",section];
        case TransformTypeRotation:
            if (section == 1)
                return @"Angle";
            else
                return @"Vector";
        case TransformTypeScale:
            return @"Scale values";
        case TransformTypeTranslation:
            return @"Translation values";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell"];
            UITextField *textField = (UITextField*)[cell.contentView viewWithTag:1];
            textField.text = self.transform.name;
            return cell;
        }
        else if (indexPath.row == 1)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell"];
            NSString *transformTypeName = [TDTransform nameForTransformType:self.transform.type];
            cell.textLabel.text = [transformTypeName stringByAppendingString:@" (tap to change)"];
            return cell;
        }
    }
    static NSArray *xyz = nil;
    if (!xyz) xyz = @[@"x",@"y",@"z"];

    TransformEditorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditorCell" forIndexPath:indexPath];
    cell.stepper.stepValue = 0.1;
    switch (self.transform.type) {
        case TransformTypeManual:
            cell.name.text = [NSString stringWithFormat:@"m%d%d",indexPath.section + 1,indexPath.row + 1];
            cell.stepper.stepValue = 0.1;
            break;
        case TransformTypeRotation:
            if (indexPath.section == 1)
            {
                cell.name.text = @"Angle (Radians)";
                cell.stepper.minimumValue = -7.0;
                cell.stepper.maximumValue = 7.0;
                cell.stepper.stepValue = M_PI_4 * 0.5;
            }
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
    cell.value.text = [[self.transform.components objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
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
    NSMutableArray *components = [[self.transform.components objectAtIndex:path.section - 1] mutableCopy];
    [components replaceObjectAtIndex:path.row withObject:cell.value.text];
    [self.transform.components replaceObjectAtIndex:path.section - 1 withObject:components];
    [self.transform updateTransform];
    [self.delegate transformEditorUpdatedTransform:self.transform requiresStackUpdate:NO ];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        TDTTransformTypeViewController *vc = [TDTTransformTypeViewController new];
        vc.delegate = self;
        vc.transformType = self.transform.type;
        self.popover = [[UIPopoverController alloc] initWithContentViewController:vc];
        self.popover.delegate = self;
        [self.popover presentPopoverFromRect:[tableView rectForRowAtIndexPath:indexPath] inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - Transform type delegate

-(void)transformTypeSelected:(TransformType)transformType
{
    [self.popover dismissPopoverAnimated:YES];
    self.transform.type = transformType;
    self.transform.transform = CATransform3DIdentity;
    [self.tableView reloadData];
    [self.delegate transformEditorUpdatedTransform:self.transform requiresStackUpdate:YES];
}

#pragma mark - Popover delegate
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    self.popover = nil;
}

#pragma mark - Text field delegate

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.transform.name = textField.text;
    [self.delegate transformEditorUpdatedTransform:self.transform requiresStackUpdate:YES];
}

@end
