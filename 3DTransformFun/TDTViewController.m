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

#pragma mark - Outlets
@property (strong, nonatomic) IBOutlet TDTTransformDemoView *transformView;
@property (strong, nonatomic) IBOutlet TDTTransformStackViewController *transformStackVC;
@property (strong, nonatomic) IBOutlet TDTTransformEditorViewController *transformEditorVC;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) UIPopoverController *popover;

@property (weak, nonatomic) IBOutlet UIButton *animateButton;
@property (nonatomic) BOOL isAnimating;

@end

@implementation TDTViewController
- (IBAction)animateTapped:(UIButton *)sender {
    self.isAnimating = !self.isAnimating;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CATransform3D sublayerTransform = CATransform3DIdentity;
    sublayerTransform.m34 = 0.0005;
    self.view.layer.sublayerTransform = sublayerTransform;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.transformView.layer.transform = [stack allTransforms];
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
    if (!isAnimating)
    {
        [self.transformView.layer removeAllAnimations];
        self.transformView.layer.transform = [self.transformStackVC allTransforms];
    }
    else
    {
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            self.transformView.layer.transform = CATransform3DIdentity;
        } completion:nil];
    }
    _isAnimating = isAnimating;
    self.animateButton.selected = isAnimating;
}
@end
