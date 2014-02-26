//
//  UserInfoManager.h
//  City 311
//
//  Created by Qian Wang on 2/8/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

@protocol UserInfoProxy <NSObject>

- (void)appendUserInfo:(NSDictionary *)userInfo serviceRequest:(NSDictionary *)request andImage:(id)image;

@end

@protocol UserInfoDelegate <NSObject>

- (void)dismissViews;

@end

@interface UserInfoManager : NSObject<UITextFieldDelegate> {
   
}

@property (assign, nonatomic) id<UserInfoProxy> proxy;
@property (assign, nonatomic) id<UserInfoDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *view;

- (void)setDefaultUserInfo;
- (void)packageServiceRequest:(NSDictionary *)request andImage:(id)image;

@end
