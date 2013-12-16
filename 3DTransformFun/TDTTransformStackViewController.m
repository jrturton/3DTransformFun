//
//  TDTTransformStackViewController.m
//  3DTransformFun
//
//  Created by Vertical Turtle on 13/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import "TDTTransformStackViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TDTTransformStackViewController ()

@property (nonatomic,strong) NSMutableArray *transformStack;

@end

@implementation TDTTransformStackViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.editing = YES;
    
    UIButton *newTransformButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newTransformButton setTitle:@"Add transform" forState:UIControlStateNormal];
    [newTransformButton addTarget:self action:@selector(newPressed:) forControlEvents:UIControlEventTouchUpInside];
    newTransformButton.frame = CGRectMake(0.0,0.0,self.tableView.frame.size.width,44.0);
    self.tableView.tableHeaderView = newTransformButton;
    self.tableView.contentOffset = CGPointZero;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.delegate transformStack:self selectedTransform:[self.transformStack objectAtIndex:0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data stack

-(NSMutableArray*)transformStack
{
    if (_transformStack) return _transformStack;
    _transformStack = [NSMutableArray arrayWithObject:[TDTransform transform]];
    return _transformStack;
}

-(void)newPressed:(UIButton*)sender
{
    [self addTransform:[TDTransform transform]];
}

-(void)addTransform:(TDTransform*)transform;
{
    [self.transformStack insertObject:transform atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.delegate transformStackChangedData:self];
}

-(void)updatedTransform:(TDTransform*)transform
{
    NSUInteger updatedRow = [self.transformStack indexOfObject:transform];
    if (updatedRow == NSNotFound) return;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:updatedRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.delegate transformStackChangedData:self];
}

-(CATransform3D)allTransforms
{
    // From the last transform to the first
    CATransform3D transform = CATransform3DIdentity;
    NSEnumerator *enumerator = [self.transformStack reverseObjectEnumerator];
    TDTransform *transformInStack;
    while ((transformInStack = [enumerator nextObject]))
    {
        transform = CATransform3DConcat(transform, transformInStack.transform);
    }
    return transform;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.transformStack count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    TDTransform *transform = [self.transformStack objectAtIndex:indexPath.row];
    cell.textLabel.text = transform.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[TDTransform nameForTransformType:transform.type]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.transformStack removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.delegate transformStackChangedData:self];
    }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    id transform = [self.transformStack objectAtIndex:fromIndexPath.row];
    [self.transformStack removeObject:transform];
    [self.transformStack insertObject:transform atIndex:toIndexPath.row];
    [self.delegate transformStackChangedData:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDTransform *transform = [self.transformStack objectAtIndex:indexPath.row];
    [self.delegate transformStack:self selectedTransform:transform];
}

@end