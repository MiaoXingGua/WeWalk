//
//  CityViewController.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "CityViewController.h"
#import "CityCell.h"
#import "QuartzCore/QuartzCore.h"

@interface CityViewController ()

@end

@implementation CityViewController
@synthesize cityList = _cityList;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"左边栏添加城市.jpg"]];
//    back.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    back.userInteractionEnabled = YES;
//    [self.view addSubview:back];
//    [back release];
    
    self.cityList = [NSMutableArray arrayWithCapacity:0];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 210, 100)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"管理城市";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [topView addSubview:titleLabel];
    
    UITextField *_textfield = [[UITextField alloc] initWithFrame:CGRectMake(5, 35, 200, 25)];
    _textfield.returnKeyType = UIReturnKeySearch;
    _textfield.delegate = self;
    _textfield.borderStyle = UITextBorderStyleNone;
    _textfield.backgroundColor = [UIColor clearColor];
    _textfield.layer.cornerRadius = 3;
    _textfield.placeholder = @"请输入城市名称";
    _textfield.font = [UIFont systemFontOfSize:18];
    _textfield.layer.borderColor = [UIColor grayColor].CGColor;
    _textfield.layer.borderWidth = 1;
    [topView addSubview:_textfield];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 200, 30)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont systemFontOfSize:13];
    cityLabel.text = @"当前城市: 北京 Beijing";
    [topView addSubview:cityLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 105, 210, self.view.frame.size.height-105) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self.cityList addObject:@"纽约 New York"];
    [self.cityList addObject:@"巴黎 Paris"];
    [self.cityList addObject:@"意大利 Italy"];
    [self.cityList addObject:@"罗马 Rome"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"cell";
    
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    
    if (cell==nil)
    {
        cell = [[CityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.citynameLable.text = [self.cityList objectAtIndex:indexPath.row];
    
    [cell.deleteBtn addTarget:self action:@selector(deleteCity:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteBtn.tag = indexPath.row;
    
    return cell;
}

- (void)deleteCity:(UIButton *)sender
{
    NSLog(@"删除第%d行",sender.tag+1);
    
    [self.cityList removeObjectAtIndex:sender.tag];
    
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
