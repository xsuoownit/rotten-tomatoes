//
//  MovieDetailsViewController.m
//  rottenTomatoes
//
//  Created by Xin Suo on 10/25/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "MBProgressHUD.h"

@interface MovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *posterOriImageView;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *imageUrl = [NSURL URLWithString: self.posterOriUrl];
    [self.posterOriImageView setImageWithURL:imageUrl];
    self.title = self.movieTitle;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
