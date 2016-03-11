//
//  ViewController.m
//  Acromine
//
//  Created by Swapnil Ratnaparkhi on 2016-03-09.
//  Copyright © 2016 Swapnil Ratnaparkhi. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
#import "AcromineCell.h"
#import "WebService.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *acromineTableView;
@property (weak, nonatomic) IBOutlet UITextField *acromineTextField;
@property (nonatomic, strong) NSMutableArray *longMeanings;
@property (weak, nonatomic) IBOutlet UILabel *noResultLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Acronyms Example";
    self.longMeanings = [NSMutableArray new];
    [self.acromineTableView registerNib:[UINib nibWithNibName:@"AcromineCell" bundle:nil] forCellReuseIdentifier:@"acrominetableviewcell"];

    [self initialSetup];
    
}

-(void)initialSetup {
    if (self.longMeanings.count <= 0) {
        self.acromineTableView.hidden = YES;
        self.noResultLabel.hidden = NO;
        self.noResultLabel.text = @"No acronyms to show.";
    } else {
        self.noResultLabel.hidden = YES;
        self.acromineTableView.hidden = NO;
        [self.acromineTableView reloadData];
    }
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.longMeanings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AcromineCell *acromineTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"acrominetableviewcell" forIndexPath:indexPath];
    if (!acromineTableViewCell) {
        acromineTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"AcromineCell" owner:self options:nil] objectAtIndex:0];
    }

    acromineTableViewCell.meanings.text = [self.longMeanings[indexPath.row][@"lf"] capitalizedString];
    acromineTableViewCell.frequenyCount.text = [NSString stringWithFormat:@"%@", self.longMeanings[indexPath.row][@"freq"]];
    acromineTableViewCell.frequencyYear.text = [NSString stringWithFormat:@"%@", self.longMeanings[indexPath.row][@"since"]];

    return acromineTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detailviewcontroller" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detailviewcontroller"]) {
        DetailViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.acromineTableView indexPathForSelectedRow];
        detailViewController.acroymnDetailName = self.longMeanings[indexPath.row][@"lf"];
        detailViewController.acroymnFrequency = [NSString stringWithFormat:@"%@", self.longMeanings[indexPath.row][@"freq"]];
        detailViewController.acroymnYear = [NSString stringWithFormat:@"%@", self.longMeanings[indexPath.row][@"since"]];
        detailViewController.acronymsArray = self.longMeanings[indexPath.row][@"vars"];
    }
    [self.acromineTableView deselectRowAtIndexPath:[self.acromineTableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - Button Action
- (IBAction)searchAcromine:(id)sender {
    [self.view endEditing:YES];

    if ([self.acromineTextField.text isEqualToString:@""] ||
        self.acromineTextField.text.length <= 1) {
        [self showAlertMessage:@"Error" message:@"Acronym text should be minimum 2 characters."];
    } else {
        [self startSearching];
    }
}

#pragma mark - Web service call
- (void)startSearching {
    __weak ViewController *weakSelf = self;
    id successHandler = ^(NSArray *results) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            weakSelf.longMeanings = [results mutableCopy];
            if (results.count == 0) {
                [weakSelf.longMeanings removeAllObjects];
            }
            [self initialSetup];
            [weakSelf.acromineTableView reloadData];
        });
    };
    
    id failureHandler = ^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showAlertMessage:@"Error" message:error.description];
            [weakSelf.longMeanings removeAllObjects];
            [self initialSetup];
            [weakSelf.acromineTableView reloadData];
        });
    };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WebService shared]acronymInformation:self.acromineTextField.text successHandler:successHandler failureHandler:failureHandler];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchAcromine:nil];
    return YES;
}

#pragma mark - Utility Menthod
-(void)showAlertMessage:(NSString *)title
                message:(NSString *)message {
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
