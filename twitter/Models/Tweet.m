//
//  Tweet.m
//  BirbNoise
//
//  Created by Jake Torres on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"

@implementation Tweet

//Init
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    if (self) {
        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if (originalTweet != nil) {
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        
        //accounting for full text in case it is not all provided
        if([dictionary valueForKey:@"full_text"] != nil) {
            self.text = dictionary[@"full_text"]; // uses full text if Twitter API provided it
        } else {
            self.text = dictionary[@"text"]; // fallback to regular text that Twitter API provided
        }
        
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        NSLog(@"%@", dictionary);
        self.replyCount = [dictionary[@"reply_count"] intValue];
        
        // Initing user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];

        //Creating time tweeted ago part of tweet
        // Format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";

        //Creating a time interval object with the difference between the current time and time the tweet was posted
        NSDate *tweetDate = [formatter dateFromString:createdAtOriginalString];
        NSDate *curDate = [NSDate date];
        NSTimeInterval diff = [curDate timeIntervalSinceDate:tweetDate];
        
        //format the createdstring based on if it was tweeted an hour or more ago or a minute or more ago
        NSInteger interval = diff;
        long seconds = interval % 60;
        long minutes = (interval / 60) % 60;
        long hours = (interval / 3600);
        if(hours > 1) {
            self.createdAtString = [NSString stringWithFormat:@"%ldh", hours];
        } else if(minutes > 1) {
            self.createdAtString = [NSString stringWithFormat:@"%ldm", minutes];
        } else {
            self.createdAtString = [NSString stringWithFormat:@"%lds", seconds];
        }
        
        
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        // Convert Date to String
        self.tweetDateForm = [formatter stringFromDate:tweetDate];
        
        formatter.dateStyle = NSDateFormatterNoStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        self.tweetTimeForm = [formatter stringFromDate:tweetDate];
        
        //checking for media
        NSDictionary *entities = dictionary[@"entities"];
        self.media = entities[@"media"];
        if(self.media) {
            NSLog(@"This tweet has media!: %@ ", self.text);
            
            self.mediaURL = self.media[0][@"media_url_https"];
            self.mediaURL = [self.mediaURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
            NSLog(@"MEDIA: %@", self.mediaURL);
        }
    }
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
