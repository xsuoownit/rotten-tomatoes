//
//  ViewController.m
//  rottenTomatoes
//
//  Created by Xin Suo on 10/21/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "MoviesViewController.h"
#import "MoviesTableViewCell.h"
#import <CoreText/CoreText.h>
#import "MovieDetailsViewController.h"
#import "MBProgressHUD.h"
#import <UIImageView+AFNetworking.h>

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSArray *filteredMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (assign) BOOL searchActive;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.networkErrorView setHidden:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.searchBar.delegate = self;
    self.searchActive = NO;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self onRefresh];
}

- (void) onRefresh {
    NSString *urlString =
    @"https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 2.0;
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:configuration
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    [self.networkErrorView setHidden:YES];
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    self.movies = responseDictionary[@"movies"];
                                                    [self.tableView reloadData];
                                                } else {
                                                    [self.networkErrorView setHidden:NO];
                                                }
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                });
                                                [self.refreshControl endRefreshing];
                                            }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchActive) {
        return [self.filteredMovies count];
    } else {
        return [self.movies count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *temp;
    if (self.searchActive) {
        temp = self.filteredMovies;
    } else {
        temp = self.movies;
    }
    
    MoviesTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    cell.titleLabel.text = temp[indexPath.row][@"title"];
    
    NSString *synopsisText = [temp[indexPath.row][@"mpaa_rating"] stringByAppendingString:[@" " stringByAppendingString:temp[indexPath.row][@"synopsis"]]];
//    NSString *boldFontName = [[UIFont boldSystemFontOfSize:22] fontName];
//    NSRange boldedRange = NSMakeRange(0, [synopsisText rangeOfString:@" "].location);
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: synopsisText];
//    [attrString beginEditing];
//    [attrString addAttribute:NSFontAttributeName value:boldFontName range:boldedRange];
//    [attrString endEditing];
//    cell.synopsisLabel.text = [attrString string];
    cell.synopsisLabel.text = synopsisText;
    
    NSString *originPosterImageUrlStr = temp[indexPath.row][@"posters"][@"thumbnail"];
    NSString *posterImageUrlStr = [[@"https://content6.flixster.com" stringByAppendingString:[originPosterImageUrlStr componentsSeparatedByString:@".net"][1]] stringByReplacingOccurrencesOfString:@"ori" withString:@"tmb"];
    NSURL *posterImageUrl = [NSURL URLWithString:posterImageUrlStr];
    
    NSURLRequest *imageUrlRequest = [NSURLRequest requestWithURL:posterImageUrl];
    [cell.posterImageView setImageWithURLRequest:imageUrlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [UIView transitionWithView:cell.posterImageView duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [cell.posterImageView setImage:image];
        } completion:nil];
    } failure:nil];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender NS_AVAILABLE_IOS(5_0) {
    NSArray *temp;
    if (self.searchActive) {
        temp = self.filteredMovies;
    } else {
        temp = self.movies;
    }
    
    MovieDetailsViewController *movieDetailsViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSString *originPosterImageUrlStr = temp[indexPath.row][@"posters"][@"thumbnail"];
    movieDetailsViewController.posterOriUrl = [@"https://content6.flixster.com" stringByAppendingString:[originPosterImageUrlStr componentsSeparatedByString:@".net"][1]];
    movieDetailsViewController.movieTitle = temp[indexPath.row][@"title"];
    movieDetailsViewController.synopsis = temp[indexPath.row][@"synopsis"];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.searchActive = NO;
        [self.searchBar setShowsCancelButton:NO];
    } else {
        self.searchActive = YES;
        [self.searchBar setShowsCancelButton:YES];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[cd] %@", searchText];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    self.searchActive = NO;
    [searchBar setShowsCancelButton:NO];
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
