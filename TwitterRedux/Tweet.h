//
//  Tweet.h
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/21/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

- (id)initWithDictionary:(NSDictionary *)rawData;

@property (strong, nonatomic) NSString *profileURL;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSString *tweetId;
@property (strong, nonatomic) NSString *retweetScreenName;
@property BOOL didFavorite;
@property BOOL didRetweet;
@property BOOL isRetweet;
@property NSInteger retweetCount;
@property NSInteger favoriteCount;
@property NSInteger authorUserId;

- (NSString *)tweetFormattedDate;
- (NSString *)tweetDetailedDate;

@end
