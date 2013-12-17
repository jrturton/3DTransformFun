//
//  TDTTransformTypeViewController.m
//  3DTransformFun
//
//  Created by Vertical Turtle on 13/10/2012.
//  Copyright (c) 2012 Vertical Turtle. All rights reserved.
//

#import "TDTTransformTypeViewController.h"

@interface TDTTransformTypeViewController ()

@property (nonatomic,strong) NSArray *transformTypes;

@end

@implementation TDTTransformTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.transformType inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
}

-(NSArray*)transformTypes
{
    if (_transformTypes) return _transformTypes;
    _transformTypes = [TDTransform transformTypeNames];
    return _transformTypes;
}

#pragma mark - UITableViewDataSource / Delegate


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.transformTypes count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.transformTypes[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.transformType inSection:0]].accessoryType = UITableViewCellAccessoryNone;
    self.transformType = indexPath.row;
    [self.delegate transformTypeSelected:self.transformType];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGSize)contentSizeForViewInPopover
{
    return CGSizeMake(320.0, 44.0 * 4);
}


@end
