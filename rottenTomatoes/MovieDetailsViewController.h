//
//  MovieDetailsViewController.h
//  rottenTomatoes
//
//  Created by Xin Suo on 10/25/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface MovieDetailsViewController : UIViewController

@property (strong, nonatomic) NSString *posterOriUrl;
@property (strong, nonatomic) NSString *movieTitle;
@property (strong, nonatomic) NSString *synopsis;

@end
