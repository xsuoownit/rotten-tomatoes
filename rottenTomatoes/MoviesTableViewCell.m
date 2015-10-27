//
//  MoviesTableViewCell.m
//  rottenTomatoes
//
//  Created by Xin Suo on 10/22/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "MoviesTableViewCell.h"

@implementation MoviesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self changeColor:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [self changeColor:highlighted];
}

- (void)changeColor:(BOOL)isChange {
    if (isChange) {
        self.titleLabel.textColor = [UIColor grayColor];
        self.synopsisLabel.textColor = [UIColor grayColor];
    } else {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.synopsisLabel.textColor = [UIColor whiteColor];
    }
}

@end
