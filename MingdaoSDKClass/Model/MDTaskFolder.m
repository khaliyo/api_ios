//
//  MDProject.m
//  MingdaoSDK
//
//  Created by Wee Tom on 13-6-5.
//  Copyright (c) 2013年 WeeTomProduct. All rights reserved.
//

#import "MDTaskFolder.h"
@implementation MDTaskFolder
- (MDTaskFolder *)initWithDictionary:(NSDictionary *)aDic
{
    self = [super init];
    if (self) {
        self.objectID = [aDic objectForKey:@"id"];
        self.objectName = [aDic objectForKey:@"name"];
        
        self.createDateString = [aDic objectForKey:@"create_time"];
        self.deadLine = [aDic objectForKey:@"deadline"];
        
        self.unreadDiscussCount = [[aDic objectForKey:@"not_count"] intValue];
        self.taskInProgressCount = [[aDic objectForKey:@"un_completedCount"] intValue];
        self.taskCompletedCount = [[aDic objectForKey:@"completed_count"] intValue];
        
        self.colorType = [[aDic objectForKey:@"color"] intValue];
        
        self.creatorID = [aDic objectForKey:@"create_user"];
        
        if ([[aDic objectForKey:@"charge_user"] isKindOfClass:[NSDictionary class]]) {
            self.charger = [[MDUser alloc] initWithDictionary:[aDic objectForKey:@"charge_user"]];
        }
        
        if ([[aDic objectForKey:@"stages"] isKindOfClass:[NSArray class]]) {
            NSArray *stageDics = aDic[@"stages"];
            NSMutableArray *stages = [NSMutableArray array];
            for (NSDictionary *sDic in stageDics) {
                MDTaskFolderStage *stage = [[MDTaskFolderStage alloc] initWithDictionary:sDic];
                [stages addObject:stage];
            }
            self.stages = stages;
        }
    }
    return self;
}

- (BOOL)isCompleted
{
    if ((self.taskInProgressCount == 0) && (self.taskCompletedCount > 0)) {
        return YES;
    }
    return NO;
}

- (id)copy
{
    id object = [[[self class] alloc] init];
    MDTaskFolder *copyObject = object;
    copyObject.objectID = [self.objectID copy];
    copyObject.objectName = [self.objectName copy];
    
    copyObject.createDateString = [self.createDateString copy];
    copyObject.deadLine = [self.deadLine copy];
    
    copyObject.unreadDiscussCount = self.unreadDiscussCount;
    copyObject.taskCompletedCount = self.taskCompletedCount;
    copyObject.taskInProgressCount = self.taskInProgressCount;
    
    copyObject.colorType = self.colorType;
    
    copyObject.creatorID = [self.creatorID copy];
    copyObject.charger = [self.charger copy];
    copyObject.stages = [self.stages copy];
    
    return copyObject;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[MDTaskFolder class]]) {
        MDTaskFolder *folder = (MDTaskFolder *)object;
        return [self.objectID isEqualToString:folder.objectID];
    }
    return NO;
}
@end