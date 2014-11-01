//
//  Constants.h
//  Buzzrd
//
//  Created by Brian Mancini on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

// Remote Notificaton received for new messages
extern NSString *const BZAppDidReceiveRoomUnreadNotification;
extern NSString *const BZAppDidReceiveRoomUnreadRoomIdKey;
extern NSString *const BZAppDidReceiveRoomUnreadMessageCountKey;

// User opened a room and the clear badge count information was recieved
extern NSString *const BZRoomDidClearBadgeNotification;
extern NSString *const BZRoomDidClearBadgeRoomKey;

// Fires when a room changes information
extern NSString *const BZRoomPropsDidChangeNotification;
extern NSString *const BZRoomPropsDidChangeRoomIdKey;
extern NSString *const BZRoomPropsDidChangePropertiesKey;
