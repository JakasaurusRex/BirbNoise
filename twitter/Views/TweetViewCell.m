//
//  TweetViewCell.m
//  BirbNoise
//
//  Created by Jake Torres on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetViewCell.h"
#import "APIManager.h"
#import "Tweet.h"

@implementation TweetViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//to check if the user just liked a tweet
- (IBAction)didTapFavorite:(id)sender {
    // TODO: Update the local tweet model
    Tweet *tweet = self.tweet;
    NSLog(@"%@", tweet);
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    // TODO: Update cell UI
    [self updateLabels];
    // TODO: Send a POST request to the POST favorites/create endpoint
    NSLog(@"%@", self);
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
         if(error){
              NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
         }
     }];
}




- (void) updateLabels{
    self.likeText.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetText.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    if(self.tweet.favorited) {
        self.likeIcon.image = [UIImage imageNamed:@"favor-icon-red"];
    }
    if(self.tweet.retweeted) {
        self.retweetIcon.image = [UIImage imageNamed:@"retweet-icon-green"];
    }
}

@end
