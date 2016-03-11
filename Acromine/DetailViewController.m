//
//  DetailViewController.m
//  Acromine
//
//  Created by Swapnil Ratnaparkhi on 2016-03-10.
//  Copyright © 2016 Swapnil Ratnaparkhi. All rights reserved.
//

#import "DetailViewController.h"
#import "AcromineCell.h"

@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *acroymnName;
@property (weak, nonatomic) IBOutlet UITableView *detailTableViewController;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Acronyms Details";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:self action:@selector(Back)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.acroymnName.text = self.acroymnDetailName;
    self.frequencyLabel.text = self.acroymnFrequency;
    self.yearLabel.text = self.acroymnYear;
    
    [self.detailTableViewController registerNib:[UINib nibWithNibName:@"AcromineCell" bundle:nil] forCellReuseIdentifier:@"acrominetableviewcell"];

}

- (IBAction)Back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.acronymsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AcromineCell *acromineTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"acrominetableviewcell" forIndexPath:indexPath];
    if (!acromineTableViewCell) {
        acromineTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"AcromineCell" owner:self options:nil] objectAtIndex:0];
    }
    
    acromineTableViewCell.meanings.text = self.acronymsArray[indexPath.row][@"lf"];
    acromineTableViewCell.frequenyCount.text = [NSString stringWithFormat:@"%@", self.acronymsArray[indexPath.row][@"freq"]];
    acromineTableViewCell.frequencyYear.text = [NSString stringWithFormat:@"%@", self.acronymsArray[indexPath.row][@"since"]];
    acromineTableViewCell.accessoryType = UITableViewCellAccessoryNone;
    
    return acromineTableViewCell;
}
@end
