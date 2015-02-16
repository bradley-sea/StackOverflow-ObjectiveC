//
//  MenuDelegate.h
//  StackOverflow
//
//  Created by Bradley Johnson on 2/14/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MenuDelegate <NSObject>

-(void)menuOptionPressed:(NSInteger)optionRow;

@end
