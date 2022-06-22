//
//  ComposeViewController.h
//  BirbNoise
//
//  Created by Jake Torres on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;

@end

@interface ComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@end




NS_ASSUME_NONNULL_END
