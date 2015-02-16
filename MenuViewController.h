//
//  MenuViewController.h
//  StackOverflow
//
//  Created by Bradley Johnson on 2/14/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDelegate.h"

@interface MenuViewController : UITableViewController 

@property (weak,nonatomic) id<MenuDelegate> delegate;

@end
