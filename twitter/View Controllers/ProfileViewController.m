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

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation ProfileViewController

- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.user);
    [self.backBtn setTitle:@"" forState:UIControlStateNormal];
    self.screennameText.text = self.user.name;
    self.usernameText.text = [@"@" stringByAppendingString:self.user.screenName];
    self.descriptionText.text = self.user.profileDesc;
    
    
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
