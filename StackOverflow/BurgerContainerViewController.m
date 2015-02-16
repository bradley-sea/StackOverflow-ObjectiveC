//
//  BurgerContainerViewController.m
//  StackOverflow
//
//  Created by Bradley Johnson on 2/14/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "BurgerContainerViewController.h"
#import "MenuViewController.h"
#import "MenuDelegate.h"

@interface BurgerContainerViewController () <MenuDelegate>

@property (strong,nonatomic) UIViewController *currentVC;
@property (strong,nonatomic) UIButton *burgerButton;
@property (strong,nonatomic) UITapGestureRecognizer *tapToCloseRecognizer;
@property (strong,nonatomic) UIPanGestureRecognizer *slideRecognizer;
@property (strong,nonatomic) UINavigationController *searchVC;

@end

@implementation BurgerContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.searchVC.view.frame = self.view.frame;
  [self addChildViewController:self.searchVC];
  [self.view addSubview:self.searchVC.view];
  [self.searchVC didMoveToParentViewController:self];
  self.currentVC = self.searchVC;
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 50, 50) ];
  [button setBackgroundImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
  [self.currentVC.view addSubview:button];
  [button addTarget:self action:@selector(burgerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  self.burgerButton = button;
  
  self.tapToCloseRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToClose)];
  self.slideRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideCurrentVC:)];
  [self.currentVC.view addGestureRecognizer:self.slideRecognizer];
  
    // Do any additional setup after loading the view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"MENU_EMBED"]) {
    MenuViewController *destinationVC = segue.destinationViewController;
    destinationVC.delegate = self;
  }
}

-(void)burgerButtonPressed {
  NSLog(@"burger pressed");
  
  self.burgerButton.userInteractionEnabled = false;
  
  __weak BurgerContainerViewController *weakSelf = self;
  
  [UIView animateWithDuration:.3 animations:^{
    weakSelf.currentVC.view.center = CGPointMake(weakSelf.currentVC.view.center.x + 300, weakSelf.currentVC.view.center.y);
    
  } completion:^(BOOL finished) {
    [weakSelf.currentVC.view addGestureRecognizer:weakSelf.tapToCloseRecognizer];
  }];
  
  
   }

-(void)tapToClose {
  [self.currentVC.view removeGestureRecognizer:self.tapToCloseRecognizer];
  
  __weak BurgerContainerViewController *weakSelf = self;
  
  [UIView animateWithDuration:.3 animations:^{
    weakSelf.currentVC.view.center = weakSelf.view.center;
    
  } completion:^(BOOL finished) {
    
    weakSelf.burgerButton.userInteractionEnabled = true;
  }];
}

-(void)slideCurrentVC:(id)sender {
  
  //clear out any animations from our view's layer
  UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)sender;
  [[[panGesture view] layer] removeAllAnimations];
  
  //grab the point of the gesture and velocity
  CGPoint translatedPoint = [panGesture translationInView:self.view];
  CGPoint velocity = [panGesture velocityInView:[sender view]];
  
  if([panGesture state] == UIGestureRecognizerStateChanged) {
    if(velocity.x > 0 || self.currentVC.view.frame.origin.x > 0) {
      self.currentVC.view.center = CGPointMake(self.currentVC.view.center.x + translatedPoint.x,self.currentVC.view.center.y);
      [panGesture setTranslation:CGPointMake(0,0) inView:self.view];
    }
  }
  
  if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded)
  {
    if (self.currentVC.view.frame.origin.x > self.view.frame.size.width/4)
    {
      //open menu
      self.burgerButton.userInteractionEnabled = false;
      [self.currentVC.view addGestureRecognizer:self.tapToCloseRecognizer];
      [UIView animateWithDuration:.3 animations:^{
        self.currentVC.view.frame = CGRectMake(self.currentVC.view.frame.size.width * .75, self.currentVC.view.frame.origin.y, self.currentVC.view.frame.size.width, self.currentVC.view.frame.size.height);
      }];
    }
    
    else
    {
      //close menu
      self.burgerButton.userInteractionEnabled = true;
      [UIView animateWithDuration:.3 animations:^{
        self.currentVC.view.frame = CGRectMake(0, self.currentVC.view.frame.origin.y, self.currentVC.view.frame.size.width, self.currentVC.view.frame.size.height);
      }];
    }
  }
}

-(void)menuOptionPressed:(NSInteger)optionRow {
  NSLog(@"%ld",(long)optionRow);
}

-(UINavigationController *)searchVC {
  if (!_searchVC) {
  _searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SEARCH_VC"];
  }
  return _searchVC;
}

@end
