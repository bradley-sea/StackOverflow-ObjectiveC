//
//  Question.m
//  StackOverflow
//
//  Created by Bradley Johnson on 2/15/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "Question.h"

@implementation Question

+ (NSArray *) questionsFromJSON:(NSData *)jsonData  {
  
  NSError* error;
  NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
  NSArray* itemsArray = jsonDictionary[@"items"];
  
  NSMutableArray* temp = [[NSMutableArray alloc] init];
  
  for (NSDictionary *item in itemsArray) {
    Question* question = [[Question alloc] init];
    question.title = (NSString *)  item[@"title"];
    NSDictionary* ownerDict = item[@"owner"];
    question.ownerAvatarURL = ownerDict[@"profile_image"];
    
    [temp addObject:question];
  }
  
  NSArray* final = [[NSArray alloc] initWithArray:temp];
  return final;
}

@end
