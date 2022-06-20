//
//  User.h
//  BirbNoise
//
//  Created by Jake Torres on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
// MARK: Properties

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) NSString *profileDesc;
@property (nonatomic, strong) NSString *joinDate;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *website;
@property (nonatomic) BOOL verified;
@property (nonatomic) BOOL isProtected;
@property (nonatomic, strong) NSString *profileBanner;
@property (nonatomic) int tweetCount;
@property (nonatomic) int followerCount;
@property (nonatomic) int followingCount;

// TODO: Create initializer
-(instancetype) initWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END
