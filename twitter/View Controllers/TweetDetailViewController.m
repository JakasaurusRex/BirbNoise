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
#import "ComposeViewController.h"
#import "ProfileViewController.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *profileBtn;

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
    
    [self.replyBtn setTitle:@"" forState:UIControlStateNormal];
    
    [self.profileBtn setTitle:@"" forState:UIControlStateNormal];
    
    //Adds images to details page
    if(self.tweet.mediaURL != nil){
        NSString *URLString = self.tweet.mediaURL;
        NSURL *url = [NSURL URLWithString:URLString];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:urlData];
        
        image = [self imageWithImage:image];
//        self.mediaView.image = [UIImage imageWithData:urlData];
//        self.mediaView.layer.cornerRadius = self.mediaView.frame.size.width/12;
//        self.mediaView.clipsToBounds = true;
//        self.mediaView.layer.borderWidth = 0.05;
//        self.mediaView.layer.masksToBounds = true;
        NSTextAttachment *attacher = [[NSTextAttachment alloc] init];
        attacher.image = image;
        NSAttributedString *stringText = [NSAttributedString attributedStringWithAttachment:attacher];

        UIFont *font = [UIFont systemFontOfSize:16.0];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                        forKey:NSFontAttributeName];
        NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:self.tweet.text attributes:attrsDictionary];
        NSMutableAttributedString *mutableString2 = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:attrsDictionary];
        [mutableString appendAttributedString:mutableString2];
        [mutableString appendAttributedString:stringText];
        
        [self.tweetText setAttributedText:mutableString];
        
    }
    // Do any additional setup after loading the view.
    
}

//go back to timeline page
- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

//pressed like
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"replySegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        Tweet *dataToPass = self.tweet;
        composeController.reply = 1;
        composeController.tweet = dataToPass;
        composeController.user = self.appUser;
     }
    if([segue.identifier isEqualToString:@"profileSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ProfileViewController *profileController = (ProfileViewController*)navigationController.topViewController;
        User *dataToPass = self.tweet.user;
        profileController.user = dataToPass;
        profileController.personal = self.isSelf;
    }
}

- (UIImage *)imageWithImage:(UIImage *)image
{
    CGFloat scale = MAX(250/image.size.width, 250/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((250 - width)/2.0f,
                                  (250 - height)/2.0f,
                                  width,
                                  height);

    CGSize cg = CGSizeMake(250, 250);
    UIGraphicsBeginImageContextWithOptions(cg, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
