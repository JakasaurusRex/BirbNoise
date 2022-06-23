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
    if(self.reply == 1) {
        [self.textView setText:[@"@" stringByAppendingString:[self.tweet.user.screenName stringByAppendingString:@" "]]];
    }
    NSString *URLString = [self.user[@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.userImage.image = [UIImage imageWithData:urlData];
    self.userImage.layer.masksToBounds = false;
    self.userImage.layer.cornerRadius = self.userImage.bounds.size.width/2;
    self.userImage.clipsToBounds = true;
    self.userImage.contentMode = UIViewContentModeScaleAspectFill;
    self.userImage.layer.borderWidth = 0.05;
}

//When user tweets
- (IBAction)onTweet:(id)sender {
    NSLog(@"Attempting to send tweet with text %@", self.textView.text);
    if(self.reply == 0) {
        [[APIManager shared] postStatusWithText:self.textView.text completion:^(Tweet *tweet, NSError *error) {
             if(error){
                  NSLog(@"Error tweeting: %@", error.localizedDescription);
             }
             else{
                 NSLog(@"Successfully tweeted the following Tweet: %@", tweet.text);
                 [self.delegate didTweet:tweet];
             }
            [self dismissViewControllerAnimated:true completion:nil];
         }];
    } else {
        [[APIManager shared] reply:self.textView.text :self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error) {
                NSLog(@"Error replying: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully tweeted the following Tweet: %@", tweet.text);
                [self.delegate didTweet:tweet];
            }
            [self dismissViewControllerAnimated:true completion:nil];
        }];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set the max character limit
    int characterLimit = 140;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.textView.text stringByReplacingCharactersInRange:range withString:text];

    // TODO: Update character count label
    self.characterText.text = [NSString stringWithFormat:@"%lu/140", newText.length];
    double length = (double) newText.length;
    self.progressBar.progress = length/140;
    
    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
}

//Dismiss modal
- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    NSLog(@"Tweet canceled");
}

- (void) textViewDidBeginEditing:(UITextView *) textView {
    if(self.reply == 0) {
        [textView setText:@""];
    } else {
        [textView setText:[@"@" stringByAppendingString:[self.tweet.user.screenName stringByAppendingString:@" "]]];
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
