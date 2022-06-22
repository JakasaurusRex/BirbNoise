//
//  User.m
//  BirbNoise
//
//  Created by Jake Torres on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    //If an object is able to be created
    if(self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.location = dictionary[@"location"];
        self.website = dictionary[@"url"];
        self.profileDesc = dictionary[@"description"];
        self.isProtected = [dictionary[@"protected"] boolValue];
        self.verified = [dictionary[@"verified"] boolValue];
        self.followerCount = [dictionary[@"followers_count"] intValue];
        self.followingCount = [dictionary[@"friends_count"] intValue];
        self.profileBanner = dictionary[@"profile_banner_url"];
        self.tweetCount = [dictionary[@"statuses_count"] intValue];
        self.joinDate = dictionary[@"created_at"];
        //initialize other props
        
        //to make sure profile picture is high quality
        self.profilePicture = [dictionary[@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    }
    return self;
}

@end
