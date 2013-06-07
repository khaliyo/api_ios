//
//  MDTag.h
//  MingdaoSDK
//
//  Created by Wee Tom on 13-6-7.
//  Copyright (c) 2013年 WeeTomProduct. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDTag : NSObject
@property (strong, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSString *objectName;
@property (assign, nonatomic) NSInteger postCount, imageCount, documentCount, faqCount, voteCount;
@property (assign, nonatomic) NSInteger totalPageSize;
- (MDTag *)initWithDictionary:(NSDictionary *)dic;
@end
