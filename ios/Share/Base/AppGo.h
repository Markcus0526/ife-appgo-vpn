//
//  AppsocksManager.h
//  AppGoPro
//
//  Created by LEI on 4/4/16.
//  Copyright © 2016 TouchingApp. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * _Nonnull sharedGroupIdentifier;
extern NSString * _Nonnull shadowsocksLogFile;
extern NSString * _Nonnull privoxyLogFile;

@interface AppGo : NSObject
+ (NSURL * _Nonnull)sharedUrl;
+ (NSUserDefaults * _Nonnull)sharedUserDefaults;

+ (NSURL * _Nonnull)sharedGeneralConfUrl;
+ (NSURL * _Nonnull)sharedSocksConfUrl;
+ (NSURL * _Nonnull)sharedProxyConfUrl;
+ (NSURL * _Nonnull)sharedHttpProxyConfUrl;
+ (NSURL * _Nonnull)sharedLogUrl;
@end
