//
//  ChatViewController.m
//  ParseChat
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "ChatViewController.h"
#import "Parse.h"
#import "ChatMessageCell.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// Instance Propertes //
@property (strong, nonatomic) NSArray<PFObject*>* messages;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up tableview
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // get messages
    [self.activityIndicator startAnimating];
    [self refreshMessages];
    
    // repeat this method every second from now
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshMessages) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message block:(void(^)(void))block {
    // create alert object
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // create the ok button
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    // show
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:block];
}

- (IBAction)sendClick:(id)sender {
    // create the message
    PFObject* message = [PFObject objectWithClassName:@"Message_fbu2018"];
    message[@"text"] = self.messageField.text;
    message[@"user"] = PFUser.currentUser;
    
    // send the message
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
             {
                 if(succeeded)
                 {
                     NSLog(@"Message sent!");
                     self.messageField.text = @"";
                 }
                 else
                 {
                     NSLog(@"Error sending message: %@.", error.localizedDescription);
                     [self showAlertWithTitle:@"Error" message:error.localizedDescription block:nil];
                 }
             }
     ];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ChatMessageCell" forIndexPath:indexPath];
    PFObject* message = self.messages[indexPath.row];
    
    // make sure message exists
    if(message != nil)
    {
        // get user
        PFUser* user = message[@"user"];
        NSString* username = (user != nil) ? user.username : @"Unknown";
        [cell setMessage:message[@"text"] username:username];
        [cell setAvatarWithUsername:username];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (void)refreshMessages {
    PFQuery* query = [PFQuery queryWithClassName:@"Message_fbu2018"];
    
    // set 20 messages limit
    query.limit = 20;
    
    // show most recent
    [query orderByDescending:@"createdAt"];
    
    // include user object
    [query includeKey:@"user"];
    
    // send query
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error)
           {
               if(error == nil)
               {
                   self.messages = objects;
               }
               else
               {
                   NSLog(@"Error receiving messages: %@.", error.localizedDescription);
               }
               [self.tableView reloadData];
               [self.activityIndicator stopAnimating];
           }
     ];
}
@end
