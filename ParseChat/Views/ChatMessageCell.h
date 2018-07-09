//
//  ChatMessageCell.h
//  ParseChat
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageCell : UITableViewCell
// Instance Methods
- (void)setMessage:(NSString*)message username:(NSString*)username;
- (void)setAvatarWithUsername:(NSString*)urlString;
@end
