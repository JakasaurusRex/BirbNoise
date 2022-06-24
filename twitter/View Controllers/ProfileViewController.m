//
//  ProfileViewController.m
//  BirbNoise
//
//  Created by Jake Torres on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TweetViewCell.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfTweets;
@end

@implementation ProfileViewController

- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.backBtn setTitle:@"" forState:UIControlStateNormal];
    self.screennameText.text = self.user.name;
    self.usernameText.text = [@"@" stringByAppendingString:self.user.screenName];
    self.descriptionText.text = self.user.profileDesc;
    
    if(!self.personal) {
        [self.logoutBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    
    if(self.user.followerCount > 1000000) {
        self.followerCount.text = [NSString stringWithFormat:@"%.1fK", ((double)self.user.followerCount)/1000000];
    } else if(self.user.followerCount > 100000) {
        self.followerCount.text = [NSString stringWithFormat:@"%.1fK", ((double)self.user.followerCount)/100000];
    } else if(self.user.followerCount > 10000) {
        self.followerCount.text = [NSString stringWithFormat:@"%.1fk", ((double)self.user.followerCount)/10000];
    } else if(self.user.followerCount > 1000) {
        self.followerCount.text = [NSString stringWithFormat:@"%.1fk", ((double)self.user.followerCount)/1000];
    } else {
        self.followerCount.text = [NSString stringWithFormat:@"%d", self.user.followerCount];
    }
    
    if(self.user.followingCount > 1000000) {
        self.followingCount.text = [NSString stringWithFormat:@"%.1fK", ((double)self.user.followingCount)/1000000];
    } else if(self.user.followingCount > 100000) {
        self.followingCount.text = [NSString stringWithFormat:@"%.1fK", ((double)self.user.followingCount)/100000];
    } else if(self.user.followingCount > 10000) {
        self.followingCount.text = [NSString stringWithFormat:@"%.1fk", ((double)self.user.followingCount)/10000];
    } else if(self.user.followingCount > 1000) {
        self.followingCount.text = [NSString stringWithFormat:@"%.1fk", ((double)self.user.followingCount)/1000];
    } else {
        self.followingCount.text = [NSString stringWithFormat:@"%d", self.user.followingCount];
    }
    
    NSString *URLString = self.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    self.otherPFP.image = nil;
    self.otherPFP.image = [UIImage imageWithData:urlData];
    
    
    //rounded corners for pfps
    self.otherPFP.layer.masksToBounds = false;
    self.otherPFP.layer.cornerRadius = self.otherPFP.frame.size.width/2;
    self.otherPFP.clipsToBounds = true;
    self.otherPFP.layer.borderWidth = 0.05;
    // Do any additional setup after loading the view.
    
    NSString *URLString2 = self.user.profileBanner;
    NSURL *url2 = [NSURL URLWithString:URLString2];
    NSData *urlData2 = [NSData dataWithContentsOfURL:url2];
    
    self.bannerPic.image = nil;
    self.bannerPic.image = [UIImage imageWithData:urlData2];
    
    [[APIManager shared] getUserTimeline:self.user :^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded user timeline");
            self.arrayOfTweets = tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting user timeline: %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayOfTweets count];
}

- (IBAction)logoutBtn:(id)sender {
    // TimelineViewController.m
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    //Clears access tokens
    [[APIManager shared] logout];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
// If there are no cells available for reuse, it will always return a cell so long as the identifier has previously been registered
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    //assigning the text in the cell to the information stored in the tweet
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    NSLog(@"%@", tweet);
    cell.tweet = tweet;
    [cell.tweetText setText:tweet.text];
    cell.tweetUser.text = self.user.name;
    tweet.user = self.user;
    
    //Better formatting for retweets and like count
    if(tweet.favoriteCount > 1000000) {
        cell.likeText.text = [NSString stringWithFormat:@"%.1fK", ((double)tweet.favoriteCount)/1000000];
    } else if(tweet.favoriteCount > 100000) {
        cell.likeText.text = [NSString stringWithFormat:@"%.1fK", ((double)tweet.favoriteCount)/100000];
    } else if(tweet.favoriteCount > 10000) {
        cell.likeText.text = [NSString stringWithFormat:@"%.1fK", ((double)tweet.favoriteCount)/10000];
    } else if(tweet.favoriteCount > 1000) {
        cell.likeText.text = [NSString stringWithFormat:@"%.1fK", ((double)tweet.favoriteCount)/1000];
    } else {
        cell.likeText.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    }
    
    if(tweet.retweetCount > 1000000) {
        cell.retweetText.text = [NSString stringWithFormat:@"%.1fK", ((double)tweet.retweetCount)/1000000];
    } else if(tweet.retweetCount > 100000) {
        cell.retweetText.text = [NSString stringWithFormat:@"%.1fK", ((double)tweet.retweetCount)/100000];
    } else if(tweet.retweetCount > 10000) {
        cell.retweetText.text = [NSString stringWithFormat:@"%.1fk", ((double)tweet.retweetCount)/10000];
    } else if(tweet.retweetCount > 1000) {
        cell.retweetText.text = [NSString stringWithFormat:@"%.1fk", ((double)tweet.retweetCount)/1000];
    } else {
        cell.retweetText.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    }
    
    cell.usernameDateText.text = [@"@" stringByAppendingString:[self.user.screenName stringByAppendingString:[@" · " stringByAppendingString:tweet.createdAtString]]];
    
    if(!self.user.verified) {
        cell.verifiedPic.alpha = 0;
    }
    
    if(tweet.favorited) {
        cell.likeIcon.image = [UIImage imageNamed:@"favor-icon-red"];
    }
    if(tweet.retweeted) {
        cell.retweetIcon.image = [UIImage imageNamed:@"retweet-icon-green"];
    }
    
    NSString *URLString = self.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    cell.userPFP.image = nil;
    cell.userPFP.image = [UIImage imageWithData:urlData];
    
    //rounded corners for pfps
    cell.userPFP.layer.masksToBounds = false;
    cell.userPFP.layer.cornerRadius = cell.userPFP.frame.size.width/2;
    cell.userPFP.clipsToBounds = true;
    cell.userPFP.layer.borderWidth = 0.05;
    

    [cell.likeBtn setTitle:@"" forState:UIControlStateNormal];

    [cell.retweetButton setTitle:@"" forState:UIControlStateNormal];
    
    [cell.replyBtn setTitle:@"" forState:UIControlStateNormal];
    [cell.pfpBtn setTitle:@"" forState:UIControlStateNormal];
    return cell;
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
