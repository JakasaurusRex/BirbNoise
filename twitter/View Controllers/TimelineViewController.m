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
    //[self.pfpButton setTitle:@"" forState:UIControlStateNormal];
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
- (IBAction)profileButton:(id)sender {
    NSLog(@"HI I AM BEING PRESSED");
}
/* will move to profile view controller when done
//Logout method
- (IBAction)didTapLogout:(id)sender {
    // TimelineViewController.m
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    //Clears access tokens
    [[APIManager shared] logout];
}
*/
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
    cell.retweetText.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.likeText.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    cell.usernameDateText.text = [@"@" stringByAppendingString:[user.screenName stringByAppendingString:[@" · " stringByAppendingString:tweet.createdAtString]]];
    
    if(!user.verified) {
        cell.verifiedPic.alpha = 0;
    }
    
    if(tweet.favorited) {
        cell.likeIcon.image = [UIImage imageNamed:@"favor-icon-red"];
    }
    if(tweet.retweeted) {
        cell.retweetIcon.image = [UIImage imageNamed:@"retweet-icon-green"];
    }
    
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
    

    [cell.likeBtn setTitle:@"" forState:UIControlStateNormal];

    [cell.retweetButton setTitle:@"" forState:UIControlStateNormal];
    
    [cell.replyBtn setTitle:@"" forState:UIControlStateNormal];
    [cell.pfpBtn setTitle:@"" forState:UIControlStateNormal];
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

}

-(void)didTweet:(Tweet *)tweet {
    NSMutableArray *tweetList = [NSMutableArray arrayWithArray:self.arrayOfTweets];
    [tweetList insertObject:tweet atIndex:0];
    self.arrayOfTweets = tweetList;
    [self.tableView reloadData];
}
/*
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
     }
}



@end
