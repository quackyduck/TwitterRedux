//
//  User.m
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/21/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "User.h"

@implementation User

static User *currentUser = nil;

- (id)initWithDictionary:(NSDictionary *)rawData {
    self = [super init];
    
    self.name = rawData[@"name"];
    self.screenName = rawData[@"screen_name"];
    self.friendCount = [rawData[@"friends_count"] integerValue];
    self.followerCount = [rawData[@"followers_count"] integerValue];
    self.statusCount = [rawData[@"statuses_count"] integerValue];
    self.userId = [rawData[@"id"] integerValue];
    
    if ([rawData[@"description"] isEqualToString:@""]) {
        self.description = rawData[@"location"];
    } else {
        self.description = rawData[@"description"];
    }
    
    NSString *profileURL = rawData[@"profile_image_url"];
    self.profileImageURL = [profileURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    
    self.profileBackgroundImageURL = [NSString stringWithFormat:@"%@/mobile_retina", rawData[@"profile_banner_url"]];
    
    return self;
}

- (NSString *)convertToString:(NSInteger)number {
    if (number > 1000000) {
        return [NSString stringWithFormat:@"%.1fM", number/1000000.0];
    } else if (number > 1000) {
        return [NSString stringWithFormat:@"%.1fK", number/1000.0];
    }
    
    return [NSString stringWithFormat:@"%d", number];
}

- (NSString *)followerCountDisplay {
    return [self convertToString:self.followerCount];
}

- (NSString *)friendCountDisplay {
    return [self convertToString:self.friendCount];
}

- (NSString *)statusCountDisplay {
    return [self convertToString:self.statusCount];
}

+ (id)currentUser {
    if (currentUser == nil) {
        NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
        if (dictionary) {
            currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return currentUser;
}

+ (void)setCurrentUser:(NSDictionary *)user {

    NSString *profileURL = user[@"profile_image_url"];
    NSString *screenName = user[@"screen_name"];
    NSString *name = user[@"name"];
    NSString *profileBackgroundURL = [NSString stringWithFormat:@"%@/mobile_retina", user[@"profile_banner_url"]];
    NSInteger userId = [user[@"id"] integerValue];
    NSInteger followerCount = [user[@"followers_count"] integerValue];
    NSInteger friendCount = [user[@"friends_count"] integerValue];
    NSInteger statusCount = [user[@"statuses_count"] integerValue];
    
    NSString *description;
    if ([user[@"description"] isEqualToString:@""]) {
        description = user[@"location"];
    } else {
        description = user[@"description"];
    }
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:profileURL forKey:@"profile_image_url"];
    [userDefaults setObject:screenName forKey:@"screen_name"];
    [userDefaults setObject:name forKey:@"name"];
    [userDefaults setObject:profileBackgroundURL forKey:user[@"profile_banner_url"]];
    [userDefaults setInteger:userId forKey:@"id"];
    [userDefaults setInteger:friendCount forKey:@"friends_count"];
    [userDefaults setInteger:followerCount forKey:@"followers_count"];
    [userDefaults setInteger:statusCount forKey:@"statuses_count"];
    [userDefaults setObject:description forKey:@"description"];
    [userDefaults synchronize];

    currentUser = [[self alloc] initWithDictionary:@{@"profile_banner_url": user[@"profile_banner_url"], @"profile_image_url": profileURL, @"screen_name": screenName, @"name": name, @"friends_count": @(friendCount), @"followers_count": @(followerCount), @"statuses_count": @(statusCount), @"id": @(userId), @"description": description}];
    
}

@end
