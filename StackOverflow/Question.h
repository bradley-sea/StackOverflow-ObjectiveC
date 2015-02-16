//
//  Question.h
//  StackOverflow
//
//  Created by Bradley Johnson on 2/15/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Question : NSObject

+ (NSArray *) questionsFromJSON:(NSData *) jsonData;

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *ownerAvatarURL;
@property (strong,nonatomic) UIImage *avatarImage;

@end
