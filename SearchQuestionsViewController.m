//
//  SearchQuestionsViewController.m
//  StackOverflow
//
//  Created by Bradley Johnson on 2/15/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "SearchQuestionsViewController.h"
#import "Question.h"
#import "StackOverflowService.h"
#import "QuestionCell.h"

@interface SearchQuestionsViewController () <UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong,nonatomic) NSArray *questions;

@end

@implementation SearchQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.tableView.dataSource = self;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 100;
  self.searchBar.delegate = self;
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.questions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SEARCH_CELL" forIndexPath:indexPath];
  Question *question = self.questions[indexPath.row];
  cell.questionTextView.text = question.title;
  
  if (question.avatarImage) {
    cell.avatarImageView.image = question.avatarImage;
  } else {
    [[StackOverflowService sharedService] fetchUserImage:question.ownerAvatarURL completionHandler:^(UIImage *image, NSError *error) {
      cell.avatarImageView.image = image;
    }];
  };
  return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [[StackOverflowService sharedService] fetchQuestionsWithSearchTerm:searchBar.text completionHandler:^(NSArray *result, NSError *error) {
      self.questions = result;
      [self.tableView reloadData];
    }];
}


@end
