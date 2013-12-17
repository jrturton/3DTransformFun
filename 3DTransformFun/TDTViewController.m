//
//  TDTViewController.m
//  3DTransformFun
//
//  Created by Vertical Turtle on 11/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import "TDTViewController.h"
#import "TDTTransformDemoView.h"
#import "TDTTransformStackViewController.h"
#import "TDTTransformTypeViewController.h"
#import "TDTTransformEditorViewController.h"

@interface TDTViewController () <TransformStackDelegate,TransformTypeDelegate,TransformEditorDelegate,UITextFieldDelegate>

@property (strong,nonatomic) TDTransform* currentTransform;

#pragma mark - Child view controllers
@property (strong, nonatomic) IBOutlet TDTTransformStackViewController *transformStackVC;
@property (strong, nonatomic) IBOutlet TDTTransformEditorViewController *transformEditorVC;

#pragma mark - Controls
@property (strong, nonatomic) IBOutlet UIButton *typeButton;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UIButton *animateButton;
@property (strong, nonatomic) IBOutlet UILabel *anchorPointXLabel;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) IBOutlet UILabel *anchorPointYLabel;
@property (strong, nonatomic) IBOutlet UILabel *anchorPointZLabel;
- (IBAction)anchorChanged:(UIStepper *)sender;

#pragma mark - Transform
@property (strong, nonatomic) IBOutlet TDTTransformDemoView *transformView;
@property (nonatomic) BOOL isAnimating;

@end

@implementation TDTViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateAnchorPointLabels];
}



#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"chooseTransformType"])
    {
        TDTTransformTypeViewController *vc = (TDTTransformTypeViewController*)segue.destinationViewController;
        vc.delegate = self;
        vc.transformType = self.currentTransform.type;
        self.popover = ((UIStoryboardPopoverSegue*)segue).popoverController;
    }
    else if ([segue.identifier isEqualToString:@"embedTable"])
    {
        self.transformStackVC = (TDTTransformStackViewController*)segue.destinationViewController;
        self.transformStackVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"embedTransformEditor"])
    {
        self.transformEditorVC = (TDTTransformEditorViewController*)segue.destinationViewController;
        self.transformEditorVC.delegate = self;
    }
}

#pragma mark - TransformStackDelegate

-(void)transformStackChangedData:(TDTTransformStackViewController *)stack
{
    BOOL restartAnimation = self.isAnimating;
    self.isAnimating = NO;
    self.transformView.gridLayer.transform = [stack allTransforms];
    self.isAnimating = restartAnimation;
}
-(void)transformStack:(TDTTransformStackViewController *)stack selectedTransform:(TDTransform *)transform
{
    self.currentTransform = transform;
}

-(void)transformStack:(TDTTransformStackViewController *)stack deletedTransform:(TDTransform *)transform
{
    if (self.currentTransform == transform)
    {
        self.currentTransform = nil;
    }
    [self transformStackChangedData:stack];
}


#pragma mark - TransformTypeChooserDelegate
-(void)transformTypeSelected:(TransformType)transformType
{
    [self.popover dismissPopoverAnimated:YES];
    self.currentTransform.type = transformType;
    self.currentTransform.transform = CATransform3DIdentity;
    [self.typeButton setTitle:[TDTransform nameForTransformType:transformType] forState:UIControlStateNormal];
    [self.transformStackVC updatedTransform:self.currentTransform];
    self.transformEditorVC.transform = self.currentTransform;
}

#pragma mark - TransformEditorDelegate

-(void)transformEditorUpdatedTransform:(TDTransform *)transform
{
    [self transformStackChangedData:self.transformStackVC];
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameField)
    {
        [self.nameField resignFirstResponder];
        return YES;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nameField)
    {
        self.currentTransform.name = textField.text;
        [self.transformStackVC updatedTransform:self.currentTransform];
    }
}

#pragma mark Accessors

-(void)setCurrentTransform:(TDTransform *)currentTransform
{
    _currentTransform = currentTransform;
    BOOL hideAccessories = currentTransform ? NO : YES;
    self.typeButton.hidden = hideAccessories;
    self.nameField.hidden = hideAccessories;
    [self.typeButton setTitle:[TDTransform nameForTransformType:currentTransform.type] forState:UIControlStateNormal];
    self.nameField.text = currentTransform.name;
    self.transformEditorVC.transform = currentTransform;
}

-(void)setIsAnimating:(BOOL)isAnimating
{

    CATransform3D transform = [self.transformStackVC allTransforms];
    if (!isAnimating)
    {
        [self.transformView.gridLayer removeAllAnimations];
        self.transformView.gridLayer.transform = transform;
    }
    else
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:transform];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.duration = 1.0;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.autoreverses = YES;
        animation.repeatCount = HUGE_VALF;
        [self.transformView.gridLayer addAnimation:animation forKey:@"transform"];
    }
    _isAnimating = isAnimating;
    self.animateButton.selected = isAnimating;
}

#pragma mark - Actions

- (IBAction)animateTapped:(UIButton *)sender
{
    self.isAnimating = !self.isAnimating;
}
- (IBAction)anchorChanged:(UIStepper *)sender
{
    CGFloat roundedValue;
    if (sender.tag == 0 || sender.tag == 1)
        roundedValue = 0.1 * roundf(10 * (CGFloat)sender.value);
    else
        roundedValue = (CGFloat)sender.value;

    CGPoint anchorPoint = self.transformView.gridLayer.anchorPoint;
    CGFloat z = self.transformView.gridLayer.anchorPointZ;

    switch (sender.tag)
    {
        case 0:
            anchorPoint.x = roundedValue;
            break;
        case 1:
            anchorPoint.y = roundedValue;
            break;
        case 2:
            z = roundedValue;
            break;
        default:
            break;
    }
    [self setTransformAnchorPoint:anchorPoint z:z];
}

-(void)setTransformAnchorPoint:(CGPoint)anchorPoint z:(CGFloat)z
{
    self.isAnimating = NO;
    [self.transformView setGridAnchorPoint:anchorPoint z:z];
    [self updateAnchorPointLabels];
}

-(void)updateAnchorPointLabels
{
    CGPoint anchorPoint = self.transformView.gridLayer.anchorPoint;
    CGFloat z = self.transformView.gridLayer.anchorPointZ;

    self.anchorPointXLabel.text = [NSString stringWithFormat:@"X: %.1f",anchorPoint.x];
    self.anchorPointYLabel.text = [NSString stringWithFormat:@"Y: %.1f",anchorPoint.y];
    self.anchorPointZLabel.text = [NSString stringWithFormat:@"Z: %.0f", z];

    CGFloat edge = self.transformView.bounds.size.width;
    self.transformView.anchorPointIndicator.position = CGPointMake(edge * anchorPoint.x, edge * anchorPoint.y);
    //TODO: This isn't working
//    self.anchorPointIndicator.transform = CATransform3DMakeTranslation(0.0, 0.0, -z);
}
@end
