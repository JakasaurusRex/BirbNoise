//
//  ComposeViewController.m
//  BirbNoise
//
//  Created by Jake Torres on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tweetButton.layer.cornerRadius = 10; // this value vary as per your desire
    self.tweetButton.clipsToBounds = YES;
    
    self.textView.delegate = self;
}

//When user tweets
- (IBAction)onTweet:(id)sender {
    NSLog(@"Attempting to send tweet with text %@", self.textView.text);
    [[APIManager shared] postStatusWithText:self.textView.text completion:^(Tweet *tweet, NSError *error) {
         if(error){
              NSLog(@"Error tweeting: %@", error.localizedDescription);
         }
         else{
             NSLog(@"Successfully tweeted the following Tweet: %@", tweet.text);
         }
        [self dismissViewControllerAnimated:true completion:nil];
     }];
}

//Dismiss modal
- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    NSLog(@"Tweet canceled");
}

- (void) textViewDidBeginEditing:(UITextView *) textView {
  [textView setText:@""];
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
