//
//  MenuViewController.m
//  StackOverflow
//
//  Created by Bradley Johnson on 2/14/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "MenuViewController.h"
#import "WebOAuthViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [userDefaults stringForKey:@"token"];
  if (!token) {
    
    WebOAuthViewController *webAuthViewController = [[WebOAuthViewController alloc]
                                                     init];
    [self presentViewController:webAuthViewController animated:true completion:^{
      
    }];
  }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.delegate menuOptionPressed:indexPath.row];
  [self.tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
