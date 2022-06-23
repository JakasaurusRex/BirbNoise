//
//  TweetDetailViewController.m
//  BirbNoise
//
//  Created by Jake Torres on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "Tweet.h"
#import "User.h"
#import "APIManager.h"

@interface TweetDetailViewController ()

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tweetText setText:self.tweet.text];
    User *user = self.tweet.user;
    self.name.text = user.name;
    self.username.text = [@"@" stringByAppendingString:user.screenName];
    self.numRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.numLikes.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.timeDotDate.text = [self.tweet.tweetTimeForm stringByAppendingString:[@" · " stringByAppendingString:self.tweet.tweetDateForm]];
    
    
    if(!user.verified) {
        self.verifiedCheck.alpha = 0;
    }
    
    if(self.tweet.favorited) {
        self.likeIcon.image = [UIImage imageNamed:@"favor-icon-red"];
    }
    if(self.tweet.retweeted) {
        self.retweetIcon.image = [UIImage imageNamed:@"retweet-icon-green"];
    }
    
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    self.profileIcon.image = nil;
    self.profileIcon.image = [UIImage imageWithData:urlData];
    
    //rounded corners for pfps
    self.profileIcon.layer.masksToBounds = false;
    self.profileIcon.layer.cornerRadius = self.profileIcon.frame.size.width/2;
    self.profileIcon.clipsToBounds = true;
    self.profileIcon.layer.borderWidth = 0.1;

    [self.likeBtn setTitle:@"" forState:UIControlStateNormal];

    [self.retweetBtn setTitle:@"" forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}
- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)pressedLike:(id)sender {
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

- (IBAction)pressedRetweet:(id)sender {
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

//function to update the labels depending upon the statuses of the variables
- (void) updateLabels{
    self.numLikes.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.numRetweets.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
