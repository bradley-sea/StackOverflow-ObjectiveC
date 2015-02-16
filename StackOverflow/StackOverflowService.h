//
//  StackOverflowService.h
//  StackOverflow
//
//  Created by Bradley Johnson on 2/15/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackOverflowService : NSObject

+(id)sharedService;
-(void)loadTokenFromUserDefaults;
- (void) fetchQuestionsWithSearchTerm:(NSString *)searchTerm completionHandler:(void (^)(NSArray * result, NSError * error))completionHandler;
- (void) fetchUserImage:(NSString *)avatarURL completionHandler:(void (^)(UIImage * image, NSError * error))completionHandler;

@end
