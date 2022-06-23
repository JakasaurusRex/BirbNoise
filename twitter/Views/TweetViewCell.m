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
#import "ComposeViewController.h"

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
    //if they were not favorited already, like the tweet
    if(self.tweet.favorited == NO) {
        // TODO: Update the local tweet model
        NSLog(@"%@", self.tweet);
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
    } else {
        //otherwise unlike the tweet
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        // TODO: Update cell UI
        [self updateLabels];
        // TODO: Send a POST request to the POST favorites/create endpoint
        NSLog(@"%@", self);
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
    }
}

//check when user clicks the retweet button
- (IBAction)didTapRetweet:(id)sender {
    // TODO: Update the local tweet model
    //if the user hadnt retweeted the tweet before
    if(self.tweet.retweeted == NO) {
        NSLog(@"%@", self.tweet);
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        // TODO: Update cell UI
        [self updateLabels];
        // TODO: Send a POST request to the POST favorites/create endpoint
        NSLog(@"%@", self);
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
             }
         }];
    } else {
        //if the user had already retweeted the tweet
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        // TODO: Update cell UI
        [self updateLabels];
        // TODO: Send a POST request to the POST favorites/create endpoint
        NSLog(@"%@", self);
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
             }
         }];
    }
}

- (IBAction)reply:(id)sender {
}


//function to update the labels depending upon the statuses of the variables
- (void) updateLabels{
    self.likeText.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetText.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    if(self.tweet.favorited) {
        self.likeIcon.image = [UIImage imageNamed:@"favor-icon-red"];
    } else {
        self.likeIcon.image = [UIImage imageNamed:@"favor-icon"];
    }
    if(self.tweet.retweeted) {
        self.retweetIcon.image = [UIImage imageNamed:@"retweet-icon-green"];
    } else {
        self.retweetIcon.image = [UIImage imageNamed:@"retweet-icon"];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}
@end
