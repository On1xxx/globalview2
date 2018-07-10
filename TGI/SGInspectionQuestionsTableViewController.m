//
//  SGInspectionQuestionsTableViewController.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionQuestionsTableViewController.h"
#import "SGInspection.h"
#import "SGQuestionTableViewCell.h"
#import "SGInspectionQuestionViewController.h"
#import "SGInspectionCategoryView.h"

@implementation SGInspectionQuestionsTableViewController {
    SGInspection *_inspection;
    BOOL _readOnly;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInspection:(SGInspection *)inspection readOnly:(BOOL)readOnly {
    _inspection = inspection;
    _readOnly = readOnly;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_inspection getCategoryCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SGInspectionCategory *category = [_inspection getCategoryAtIndex:section];
    if (category.collapsed) {
        return 0;
    } else {
        return [category getQuestionCount];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SGInspectionCategory *category = [_inspection getCategoryAtIndex:section];
    return category.title;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SGInspectionCategory *category = [_inspection getCategoryAtIndex:section];
    if (!category.view) {
        category.view = [[SGInspectionCategoryView alloc] initWithCategory:category];
        category.tableView = self.tableView;
    }
    return category.view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SGInspectionCategory *category = [_inspection getCategoryAtIndex:indexPath.section];
    SGInspectionQuestion *question = [category getQuestionAtIndex:indexPath.row];
    
    NSLog(@"%@, repaired: %d", question.title, question.repaired);
    
    SGQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QUESTION_INFO" forIndexPath:indexPath];
    cell.titleLabel.text = question.title;
    switch (question.status) {
        case SGInspectionQuestionStatusPass:
            cell.statusLabel.text = @"Pass";
            break;
        case SGInspectionQuestionStatusFail:
            cell.statusLabel.text = @"Fail";
            break;
        case SGInspectionQuestionStatusSkip:
            cell.statusLabel.text = @"Skip";
            break;
    }
    cell.repairedSwitch.on = question.repaired;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *path = [self.tableView indexPathForCell:sender];
    SGInspectionQuestionViewController *controller = segue.destinationViewController;
    controller.inspection = _inspection;
    controller.categoryIndex = path.section;
    controller.questionIndex = path.row;
    controller.readOnly = _readOnly;
}

@end
