//
//  Tweet.h
//  BirbNoise
//
//  Created by Jake Torres on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSObject
@property (nonatomic, strong) NSString *idStr; // For favoriting, retweeting & replying
@property (nonatomic, strong) NSString *text; // Text content of tweet
@property (nonatomic) int favoriteCount; // Update favorite count label
@property (nonatomic) BOOL favorited; // Configure favorite button
@property (nonatomic) int retweetCount; // Update favorite count label
@property (nonatomic) BOOL retweeted;
@property (nonatomic) int replyCount;
@property (nonatomic, strong) User *user; // Contains Tweet author's name, screenname, etc.
@property (nonatomic, strong) NSString *createdAtString; // Display date
@property (nonatomic, strong) NSString *tweetDateForm;
@property (nonatomic, strong) NSString *tweetTimeForm;
//for embeded images
@property (nonatomic, strong) NSArray *media;
@property (nonatomic, strong) NSString *mediaURL;
//For retweets
@property (nonatomic, strong) User *retweetedByUser;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries;
@end

NS_ASSUME_NONNULL_END
