//
//  Constants.h
//  Buzzrd
//
//  Created by Brian Mancini on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

// On Push Notification
extern NSString *const BZAppDidReceivePushNotification;

// Authentication and deauthentication events
extern NSString *const BZUserDidAuthenticateNotification;
extern NSString *const BZUserWillDeauthenticateNotification;

// Remote Notificaton received for new messages
extern NSString *const BZAppDidReceiveRoomUnreadNotification;
extern NSString *const BZAppDidReceiveRoomUnreadRoomIdKey;

// User opened a room and the clear badge count information was recieved
extern NSString *const BZRoomDidClearBadgeNotification;
extern NSString *const BZRoomDidClearBadgeRoomKey;

// Fires when a room changes information
extern NSString *const BZRoomPropsDidChangeNotification;
extern NSString *const BZRoomPropsDidChangeRoomIdKey;
extern NSString *const BZRoomPropsDidChangePropertiesKey;
