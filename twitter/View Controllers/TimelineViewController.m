//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "User.h"
#import "TweetViewCell.h"
#import "ComposeViewController.h"
#import "TweetDetailViewController.h"
#import "ProfileViewController.h"
#include <math.h>

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayOfTweets;
@property (nonatomic, strong) NSDictionary *appUserProfile;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //Pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    //Buttons automatically put text on themselves for some reason, this is what i did throuhgout my code to stop that
    [self.barPFP setTitle:@"" forState:UIControlStateNormal];
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
    //Get the user who is using the app
    [[APIManager shared] getSelfProfile:^(NSDictionary *user, NSError *error) {
        if(user) {
            NSLog(@"😎😎😎 Successfully loaded user info");
            self.appUserProfile = user;
            NSString *URLString = [self.appUserProfile[@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
            NSURL *url = [NSURL URLWithString:URLString];
            
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            self.navImage.image = [UIImage imageWithData:urlData];
            
            self.navImage.layer.masksToBounds = false;
            self.navImage.layer.cornerRadius = self.navImage.bounds.size.width/2;
            self.navImage.clipsToBounds = true;
            self.navImage.contentMode = UIViewContentModeScaleAspectFill;
            self.navImage.layer.borderWidth = 0.05;
        } else {
            NSLog(@"😫😫😫 Error getting user information: %@", error.localizedDescription);
        }
    }];
    
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Table View Functions
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
// If there are no cells available for reuse, it will always return a cell so long as the identifier has previously been registered
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    //assigning the text in the cell to the information stored in the tweet
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    cell.tweet = tweet;
    [cell.tweetText setText:tweet.text];
    User *user = tweet.user;
    cell.tweetUser.text = user.name;
    
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
    
    //@user dot time since post format
    cell.usernameDateText.text = [@"@" stringByAppendingString:[user.screenName stringByAppendingString:[@" · " stringByAppendingString:tweet.createdAtString]]];
    
    //if user is verified check
    if(!user.verified) {
        cell.verifiedPic.alpha = 0;
    }
    
    //sets icons based on tweet state
    if(tweet.favorited) {
        cell.likeIcon.image = [UIImage imageNamed:@"favor-icon-red"];
    } else {
        cell.likeIcon.image = [UIImage imageNamed:@"favor-icon"];
    }
    if(tweet.retweeted) {
        cell.retweetIcon.image = [UIImage imageNamed:@"retweet-icon-green"];
    } else {
        cell.retweetIcon.image = [UIImage imageNamed:@"retweet-icon"];
    }
    
    //pfp stuff
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    cell.userPFP.image = nil;
    cell.userPFP.image = [UIImage imageWithData:urlData];
    
    //rounded corners for pfps
    cell.userPFP.layer.masksToBounds = false;
    cell.userPFP.layer.cornerRadius = cell.userPFP.frame.size.width/2;
    cell.userPFP.clipsToBounds = true;
    cell.userPFP.layer.borderWidth = 0.05;
    

    //BUTTONS
    [cell.likeBtn setTitle:@"" forState:UIControlStateNormal];

    [cell.retweetButton setTitle:@"" forState:UIControlStateNormal];
    
    [cell.replyBtn setTitle:@"" forState:UIControlStateNormal];
    [cell.pfpBtn setTitle:@"" forState:UIControlStateNormal];
    
    //if a tweet has an image
    if(cell.tweet.mediaURL != nil){
        NSString *URLString = cell.tweet.mediaURL;
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

        UIFont *font = [UIFont systemFontOfSize:13.0];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                        forKey:NSFontAttributeName];
        NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:cell.tweet.text attributes:attrsDictionary];
        NSMutableAttributedString *mutableString2 = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:attrsDictionary];
        [mutableString appendAttributedString:mutableString2];
        [mutableString appendAttributedString:stringText];
        
        [cell.tweetText setAttributedText:mutableString];
        
    }
    
    return cell;
}

//returns the amount of rows in the tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayOfTweets count];
}

//Deselcting cell after it is clicked on
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

//refresh control method
- (void)beginRefresh:(UIRefreshControl *)refreshControl {

    // Create NSURL and NSURLRequest
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.arrayOfTweets = tweets;
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
            [refreshControl endRefreshing];
        }
    }];
    
    //Also get user profile
    [[APIManager shared] getSelfProfile:^(NSDictionary *user, NSError *error) {
        if(user) {
            NSLog(@"😎😎😎 Successfully loaded user info");
            self.appUserProfile = user;
            NSString *URLString = [self.appUserProfile[@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
            NSURL *url = [NSURL URLWithString:URLString];
            
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            self.navImage.image = [UIImage imageWithData:urlData];
            
            self.navImage.layer.masksToBounds = false;
            self.navImage.layer.cornerRadius = self.navImage.bounds.size.width/2;
            self.navImage.clipsToBounds = true;
            self.navImage.contentMode = UIViewContentModeScaleAspectFill;
            self.navImage.layer.borderWidth = 0.05;
        } else {
            NSLog(@"😫😫😫 Error getting user information: %@", error.localizedDescription);
        }
    }];

}

//if the user composed a tweet, this function is called
-(void)didTweet:(Tweet *)tweet {
    NSMutableArray *tweetList = [NSMutableArray arrayWithArray:self.arrayOfTweets];
    [tweetList insertObject:tweet atIndex:0];
    self.arrayOfTweets = tweetList;
    [self.tableView reloadData];
}

/* This is the infinite scroll code, i didnt really like it so i just loaded 200 tweets instead.
//Infinite Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     // Handle scroll behavior here
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
        }
    }
}

-(void)loadMoreData{
    
      // ... Create the NSURLRequest (myRequest) ...
    
    // Configure session so that completion handler is executed on main UI thread
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session  = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
   
    
    [task resume];
}*/


//for tweets with images (adjusts the size to 250 by 250)
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([segue.identifier isEqualToString:@"composeSegue"]) {
         UINavigationController *navigationController = [segue destinationViewController];
         ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
         composeController.delegate = self;
         composeController.reply = 0;
         composeController.user = self.appUserProfile;
     } else if([segue.identifier isEqualToString:@"detailSegue"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
         Tweet *dataToPass = self.arrayOfTweets[indexPath.item];
         UINavigationController *navCon = [segue destinationViewController];
         TweetDetailViewController *detailVC = (TweetDetailViewController *)navCon.topViewController;
         detailVC.tweet = dataToPass;
         if(dataToPass.user.screenName == self.appUserProfile[@"screen_name"]) {
             detailVC.isSelf = 1;
         } else {
             detailVC.isSelf = 0;
         }
         detailVC.appUser = self.appUserProfile;
     } else if([segue.identifier isEqualToString:@"replySegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
         UIView *content = (UIView *)[(UIView *) sender superview];
         TweetViewCell *cell = (TweetViewCell *)[content superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Tweet *dataToPass = self.arrayOfTweets[indexPath.item];
        composeController.reply = 1;
        composeController.tweet = dataToPass;
        composeController.user = self.appUserProfile;
     } else if([segue.identifier isEqualToString:@"otherProfileSegue"]) {
         UINavigationController *navigationController = [segue destinationViewController];
         ProfileViewController *profileController = (ProfileViewController*)navigationController.topViewController;
         UIView *content = (UIView *)[(UIView *) sender superview];
         TweetViewCell *cell = (TweetViewCell *)[content superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Tweet *tweetToPass = self.arrayOfTweets[indexPath.item];
         User *user = tweetToPass.user;
         profileController.user = user;
         profileController.personal = 0;
     } else if([segue.identifier isEqualToString:@"profileSegue"]) {
         UINavigationController *navigationController = [segue destinationViewController];
         ProfileViewController *profileController = (ProfileViewController*)navigationController.topViewController;
         profileController.user = [[User alloc] initWithDictionary:self.appUserProfile];
         profileController.personal = 1;
     }
}



@end
