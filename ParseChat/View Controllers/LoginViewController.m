//
//  LoginViewController.m
//  ParseChat
//
//  Created by César Francisco Barraza on 7/9/18.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse.h"

@interface LoginViewController ()
// Outlet Definitions //
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (IBAction)loginClick:(id)sender {
    NSString* username = self.usernameField.text;
    NSString* password = self.passwordField.text;
    
    // validate textfields
    if([self.usernameField.text length] <= 0 || [self.passwordField.text length] <= 0)
    {
        [self showAlertWithTitle:@"Login Error" message:@"Please fill in a username and password." block:nil];
    }
    
    // log in
    [PFUser logInWithUsernameInBackground:username password:password
            block:^(PFUser * _Nullable user, NSError * _Nullable error)
            {
                if(error == nil)
                {
                    // login
                    NSLog(@"User %@ logged in successfully.", user.username);
                    [self performSegueWithIdentifier:@"loginSegue" sender:self];
                }
                else
                {
                    // show them the error
                    [self showAlertWithTitle:@"Login Error" message:error.localizedDescription block:nil];
                }
            }
     ];
}

- (IBAction)registerClick:(id)sender {
    PFUser* newUser = [PFUser user];
    
    // validate textfields
    if([self.usernameField.text length] <= 0 || [self.passwordField.text length] <= 0)
    {
        [self showAlertWithTitle:@"Register Error" message:@"Please fill in a username and password." block:nil];
    }
    
    // get the text from outlets
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    // sign up
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error)
             {
                 if(error == nil)
                 {
                     // login after they tap OK
                     [self showAlertWithTitle:@"Success" message:[NSString stringWithFormat:@"User %@ registered successfully.", newUser.username]
                           block:^
                           {
                               [self performSegueWithIdentifier:@"loginSegue" sender:self];
                           }
                      ];
                 }
                 else
                 {
                     // show them the error
                     [self showAlertWithTitle:@"Register Error" message:error.localizedDescription block:nil];
                 }
             }
     ];
}
@end
