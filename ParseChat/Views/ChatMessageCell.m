//
//  ChatMessageCell.m
//  ParseChat
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ChatMessageCell.h"

@interface ChatMessageCell ()
// Outlet Definitions
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *bubbleImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@end

@implementation ChatMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // set rounded corners
    self.bubbleImage.layer.cornerRadius = 16;
    self.bubbleImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMessage:(NSString*)message username:(NSString*)username {
    self.messageLabel.text = message;
    self.usernameLabel.text = username;
}
@end
