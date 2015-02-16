//
//  StackOverflowService.m
//  StackOverflow
//
//  Created by Bradley Johnson on 2/15/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "StackOverflowService.h"
#import "Question.h"

@interface StackOverflowService()

@property (strong,nonatomic) NSString *accessToken;

@end

@implementation StackOverflowService

static NSString *const stackOverFlowURL = @"https://api.stackexchange.com/2.2/";
static NSString *const stackOverFlowRequestKey = @"5Vpg3uTqCwAssGUjZx73wg((";

+(id)sharedService {
  static StackOverflowService *mySharedService = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
    mySharedService = [[self alloc] init];
    [mySharedService loadTokenFromUserDefaults];
  });
  return mySharedService;
}

-(void)loadTokenFromUserDefaults {
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [userDefaults stringForKey:@"token"];
  
  if (token) {
    self.accessToken = token;
  }
}

- (void) fetchQuestionsWithSearchTerm:(NSString *)searchTerm completionHandler:(void (^)(NSArray * result, NSError * error))completionHandler {
  
  NSString *urlString = stackOverFlowURL;
  urlString = [urlString stringByAppendingString:@"search?order=desc&sort=activity&filter=withbody&intitle="];
  urlString = [urlString stringByAppendingString:searchTerm];
  urlString = [urlString stringByAppendingString:@"&site=stackoverflow"];
  urlString = [urlString stringByAppendingString:@"&access_token="];
  urlString = [urlString stringByAppendingString:self.accessToken];
  urlString = [urlString stringByAppendingString:@"&key="];
  urlString = [urlString stringByAppendingString:stackOverFlowRequestKey];
  //urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

  NSURL *url = [[NSURL alloc] initWithString:urlString];
  
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"GET";
  NSURLSession *session = [NSURLSession sharedSession];
  
  
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"%@",error.localizedDescription);
    } else {
      NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)response;
      NSInteger statusCode = [httpResponse statusCode];
      switch (statusCode) {
        case 200: {
          NSArray *results = [Question questionsFromJSON:data];
          dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(results,nil);
          });
        }
          break;
        default:
          //return error;
          break;
      }
    }
  }];
  [dataTask resume];
}

- (void) fetchUserImage:(NSString *)avatarURL completionHandler:(void (^)(UIImage * image, NSError * error))completionHandler {
  
    dispatch_queue_t imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  
  dispatch_async(imageQueue, ^{
    
    NSURL *url = [NSURL URLWithString:avatarURL];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      completionHandler(image,nil);
    });
  });
}



@end
