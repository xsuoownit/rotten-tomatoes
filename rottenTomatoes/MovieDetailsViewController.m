//
//  MovieDetailsViewController.m
//  rottenTomatoes
//
//  Created by Xin Suo on 10/25/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "MBProgressHUD.h"

@interface MovieDetailsViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *posterOriImageView;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIView *textBGView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.title = self.movieTitle;
    self.titleLabel.text = self.movieTitle;
    NSString *score = [NSString stringWithFormat:@"%@: %@, %@: %@", @"Audience Score", self.audienceScore, @"Critics Score", self.criticsScore];
    self.scoreLabel.text = score;
    
    self.synopsisLabel.text = self.synopsis;
    [self.synopsisLabel sizeToFit];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.synopsisLabel.frame.origin.y + self.synopsisLabel.frame.size.height);
    self.textBGView.frame = CGRectMake(self.textBGView.frame.origin.x, self.textBGView.frame.origin.y, self.textBGView.frame.size.width, self.scrollView.frame.size.height);
    
    NSURL *imageTmbUrl = [NSURL URLWithString:self.posterTmbUrl];
    [self.posterOriImageView setImageWithURL:imageTmbUrl];
    
    NSURL *imageUrl = [NSURL URLWithString: self.posterOriUrl];
    NSURLRequest *imageUrlRequest = [NSURLRequest requestWithURL:imageUrl];
    __weak UIImageView *weakSelf = self.posterOriImageView;
    [self.posterOriImageView setImageWithURLRequest:imageUrlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIImage *cachedImage = [[[weakSelf class] sharedImageCache] cachedImageForRequest:request];
        if (cachedImage) // image was cached
            [weakSelf setImage:image];
        else
            [UIView transitionWithView:weakSelf duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [weakSelf setImage:image];
            } completion:nil];
    } failure:nil];
    
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
