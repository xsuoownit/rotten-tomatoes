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

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
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
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    self.movies = responseDictionary[@"movies"];
                                                    [self.tableView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                                [self.refreshControl endRefreshing];
                                            }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoviesTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    cell.titleLabel.text = self.movies[indexPath.row][@"title"];
    
    NSString *synopsisText = [self.movies[indexPath.row][@"mpaa_rating"] stringByAppendingString:[@" " stringByAppendingString:self.movies[indexPath.row][@"synopsis"]]];
//    NSString *boldFontName = [[UIFont boldSystemFontOfSize:22] fontName];
//    NSRange boldedRange = NSMakeRange(0, [synopsisText rangeOfString:@" "].location);
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: synopsisText];
//    [attrString beginEditing];
//    [attrString addAttribute:NSFontAttributeName value:boldFontName range:boldedRange];
//    [attrString endEditing];
//    cell.synopsisLabel.text = [attrString string];
    cell.synopsisLabel.text = synopsisText;
    
    NSString *originPosterImageUrlStr = self.movies[indexPath.row][@"posters"][@"thumbnail"];
    NSString *posterImageUrlStr = [[@"https://content6.flixster.com" stringByAppendingString:[originPosterImageUrlStr componentsSeparatedByString:@".net"][1]] stringByReplacingOccurrencesOfString:@"ori" withString:@"tmb"];
    NSURL *posterImageUrl = [NSURL URLWithString:posterImageUrlStr];
    
    [cell.posterImageView setImageWithURL:posterImageUrl];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender NS_AVAILABLE_IOS(5_0) {
    MovieDetailsViewController *movieDetailsViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSString *originPosterImageUrlStr = self.movies[indexPath.row][@"posters"][@"thumbnail"];
    movieDetailsViewController.posterOriUrl = [@"https://content6.flixster.com" stringByAppendingString:[originPosterImageUrlStr componentsSeparatedByString:@".net"][1]];
    movieDetailsViewController.movieTitle = self.movies[indexPath.row][@"title"];
    movieDetailsViewController.synopsis = self.movies[indexPath.row][@"synopsis"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
