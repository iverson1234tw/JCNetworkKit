//
//  JCViewController.m
//  JCNetworkKit
//
//  Created by Chen Hung-Wei on 05/04/2020.
//  Copyright (c) 2020 Chen Hung-Wei. All rights reserved.
//

#import "JCViewController.h"
#import <JCNetworkKit/JCNetwork.h>

@interface JCViewController () <UITableViewDelegate, UITableViewDataSource> {
    UIView *titleView;
    NSArray *methodArray;
}
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation JCViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    methodArray = [NSArray arrayWithObjects:@"GET", @"POST", @"DELETE", nil];
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    titleView.backgroundColor = KKW_WHITE;
    
    [self.view addSubview:titleView];

    [self init_tableview];
    
}

- (void)init_tableview {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleView.frame.origin.y + titleView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - titleView.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = false;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [methodArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld", indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = methodArray[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.detailsLabel.text = @"Loading";
        
        [[JCNetwork sharedManager] requestWithMethod:GET WithPath:[NSString stringWithFormat:@"%@/try-jcnetwork-api", JC_HostName] WithParams:@{} WithFile:@[] WithSuccessBlock:^(id responseObject) {
            
            [hud hideAnimated:YES];
            
            NSLog(@"%@", responseObject);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:[NSString stringWithFormat:@"%@", responseObject[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        } WithFailurBlock:^(NSError *error) {
            
            [hud hideAnimated:YES];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"ErrorCode:%ld",error.code] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }];
        
    } else if (indexPath.row == 1) {
        
        UIAlertController *alertVC =[UIAlertController alertControllerWithTitle:@"Question" message:@"What's your name?" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"Answer";
            textField.textColor = [UIColor blackColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            
        }];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSDictionary *params = @{
                                     @"name": [NSString stringWithFormat:@"%@", alertVC.textFields[0].text]
                                     };
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.detailsLabel.text = @"Loading";
            
            [[JCNetwork sharedManager] requestWithMethod:POST WithPath:[NSString stringWithFormat:@"%@/try-jcnetwork-api", JC_HostName] WithParams:params WithFile:@[] WithSuccessBlock:^(id responseObject) {
                
                [hud hideAnimated:YES];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:[NSString stringWithFormat:@"%@", responseObject[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            } WithFailurBlock:^(NSError *error) {
                
                [hud hideAnimated:YES];
                
                NSLog(@"%@", error.description);
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"ErrorCode:%ld",error.code] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            }];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alertVC addAction:action];
        [alertVC addAction:cancel];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    } else if (indexPath.row == 2) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Delete Method" message:@"Input the object you want to delete" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"Object";
            textField.textColor = [UIColor blackColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                        
        }];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSDictionary *params = @{
                                     @"object": [NSString stringWithFormat:@"%@", alertVC.textFields[0].text]
                                     };
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.detailsLabel.text = @"Loading";
            
            [[JCNetwork sharedManager] requestWithMethod:DELETE WithPath:[NSString stringWithFormat:@"%@/try-jcnetwork-api", JC_HostName] WithParams:params WithFile:@[] WithSuccessBlock:^(id responseObject) {
                
                [hud hideAnimated:YES];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:[NSString stringWithFormat:@"%@", responseObject[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            } WithFailurBlock:^(NSError *error) {
                
                [hud hideAnimated:YES];
                
                NSLog(@"%@", error.description);
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"ErrorCode:%ld",error.code] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            }];
            
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alertVC addAction:action];
        [alertVC addAction:cancel];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
