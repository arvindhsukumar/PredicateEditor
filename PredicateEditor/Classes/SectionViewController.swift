//
//  SectionViewController.swift
//  PredicateEditor
//
//  Created by Arvindh Sukumar on 09/07/16.
//
//

import UIKit
import SnapKit

class SectionViewController: UIViewController {
    var config: PredicatorEditorConfig!
    var section: Section!
    let sectionView: SectionView = {
        let sectionView = SectionView(frame: CGRectZero)
        sectionView.layer.masksToBounds = false
        sectionView.layer.borderColor = UIColor(white: 0.9, alpha: 1).CGColor
        sectionView.layer.borderWidth = 1
        sectionView.layer.cornerRadius = 4
        return sectionView
    }()
    
    convenience init(section:Section, config: PredicatorEditorConfig){
        self.init(nibName: nil, bundle: nil)
        self.section = section
        self.config = config
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView(){
        sectionView.delegate = self
        sectionView.dataSource = self
        sectionView.config = config
        view.addSubview(sectionView)
        sectionView.snp_makeConstraints {
            make in
            make.edges.equalTo(view).inset(10)
        }
        sectionView.reloadData()
    }
}

extension SectionViewController {
    func showKeyPathOptions(forRow row: Row) {
        guard let section = row.section else {return}
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for property in section.keyPathTitles {
            let action = UIAlertAction(title: property, style: UIAlertActionStyle.Default, handler: { (action) in
                row.descriptor = section.descriptorWithTitle(property)
                var newComparisonType: KeyPathComparisonType?
                if let comparisonTypes = row.descriptor?.propertyType.comparisonTypes()
                {
                    if let currentComparisonType = row.comparisonType where comparisonTypes.contains(currentComparisonType) {
                        newComparisonType = currentComparisonType
                    }
                    else {
                        newComparisonType = row.descriptor?.propertyType.comparisonTypes().first
                    }
                }
                
                row.comparisonType = newComparisonType
                row.resetBaseValue()
                if let index = row.index {
                    self.sectionView.reloadItemAtIndex(index)
                }
            })
            sheet.addAction(action)
        }
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    func showComparisonOptions(forRow row: Row) {
        guard let descriptor = row.descriptor else { return }
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let keyPathType = descriptor.propertyType
        let comparisonOptions = keyPathType.comparisonTypes().map { (type) -> String in
            return type.rawValue
        }
        
        for comparison in comparisonOptions {
            let action = UIAlertAction(title: comparison, style: UIAlertActionStyle.Default, handler: { (action) in
                
                row.comparisonType = KeyPathComparisonType(rawValue: comparison)
                if let index = row.index {
                    self.sectionView.reloadItemAtIndex(index)
                }
            })
            sheet.addAction(action)
        }
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    func showEnumerationOptions(forRow row: Row) {
        guard let descriptor = row.descriptor where descriptor.enumerationOptions.count > 0 else { return }
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for option in descriptor.enumerationOptions {
            let action = UIAlertAction(title: option, style: UIAlertActionStyle.Default, handler: { (action) in
                
                row.stringValue = option
                if let index = row.index {
                    print("reloading item at index \(row.index)")
                    self.sectionView.reloadItemAtIndex(index)
                }
            })
            sheet.addAction(action)
        }
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    func showCompoundPredicateOptions() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for option in ["Any", "All"] {
            let action = UIAlertAction(title: option, style: UIAlertActionStyle.Default, handler: { (action) in                
                self.section.compoundPredicateType = (option == "Any" ? .OR : .AND)
                self.sectionView.reloadCompoundPredicateButton()
            })
            sheet.addAction(action)
        }
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(sheet, animated: true, completion: nil)
    }
    
    func showDatePicker(row: Row,date: NSDate? = nil, mode: UIDatePickerMode = .Date) {
        let datePicker = DatePickerViewController()
        datePicker.datePickerMode = mode
        datePicker.row = row
        datePicker.date = date
        datePicker.delegate = self
        datePicker.transitioningDelegate = self
        datePicker.modalPresentationStyle = .Custom
        presentViewController(datePicker, animated: true, completion: nil)
    }
}

extension SectionViewController: SectionViewDelegate, SectionViewDataSource {
    func sectionViewChooseCompoundPredicateType() {
        showCompoundPredicateOptions()
    }
    
    func sectionViewCompoundPredicateType() -> SectionPredicateType {
        return section.compoundPredicateType
    }
    
    func sectionViewWillInsertRow() {
        section.append(Row())
        sectionView.insertRowView()        
    }
    
    func sectionViewTitle() -> String {
        return section.title
    }

    func sectionViewNumberOfRows() -> Int {
        return section.rows.count
    }

    func sectionViewRowForItemAtIndex(index: Int) -> UIView {
        var rowView: RowView!
        if index < sectionView.rowViews.count {
            let view = sectionView.rowViews[index]
            rowView = view as! RowView
        }
        else {
            let view = RowView(frame: CGRectZero)
            view.delegate = self
            view.config = config
            view.tag = index
            view.backgroundColor = UIColor.whiteColor()
            rowView = view
        }
        let row = section.rows[index]
        rowView.configureWithRow(row)
        return rowView
    }
}

extension SectionViewController: RowViewDelegate {
    func didTapKeyPathButtonInRowView(rowView: RowView) {
        guard let index = sectionView.indexOfRowView(rowView) else {return}
        let row = section.rows[index]
        print(row.descriptor?.keyPath)
        showKeyPathOptions(forRow: row)
    }
    
    func didTapComparisonButtonInRowView(rowView: RowView) {
        guard let index = sectionView.indexOfRowView(rowView) else {return}
        print("did tap comparison in row \(index)")
        let row = section.rows[index]
        print(row.comparisonType)
        showComparisonOptions(forRow: row)
    }
    
    func didTapInputButtonInRowView(rowView: RowView) {
        guard let index = sectionView.indexOfRowView(rowView) else {return}
        let row = section.rows[index]
        if let options = row.descriptor?.enumerationOptions where options.count > 0 {
            showEnumerationOptions(forRow: row)
        }
        else {
            guard let propertyType = row.descriptor?.propertyType where (propertyType == .Date || propertyType == .DateTime || propertyType == .Time) else {return}
            
            var datePickerMode: UIDatePickerMode!
            switch propertyType {
            case .Date:
                datePickerMode = .Date
            case .DateTime:
                datePickerMode = .DateAndTime
            case .Time:
                datePickerMode = .Time
            default:
                datePickerMode = .Date
            }
            showDatePicker(row, date: row.value as? NSDate, mode: datePickerMode)
        }
    }
    
    func didTapDeleteButtonInRowView(rowView: RowView) {
        guard let index = sectionView.indexOfRowView(rowView) else {return}
        let row = section.rows[index]
        sectionView.deleteRowAtIndex(index)
        section.deleteRow(row)
    }
    
    func inputValueChangedInRowView(rowView: RowView, value: String?) {
        guard let index = sectionView.indexOfRowView(rowView) else {return}
        let row = section.rows[index]
        row.stringValue = value
    }
}

extension SectionViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let semiModalTransition = SemiModalTransition()
        semiModalTransition.presenting = true
        return semiModalTransition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let semiModalTransition = SemiModalTransition()
        return semiModalTransition

    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return SemiModalPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
}

extension SectionViewController: DatePickerDelegate {
    func datePickerDidSelectDate(row: Row, date: NSDate, datePickerMode: UIDatePickerMode) {
        row.value = date
        if let index = row.index {
            print("reloading item at index \(row.index)")
            self.sectionView.reloadItemAtIndex(index)
        }
    }
}

class SemiModalPresentationController : UIPresentationController {
    let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.alpha = 0
        return view
    }()
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        setupDimmingView()
    }
    
    func setupDimmingView() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(SemiModalPresentationController.dismissPresentedViewController(_:)))
        dimmingView.addGestureRecognizer(tapGR)
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        let containerSize = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerView!.bounds.size)
        return CGRect(x: 0, y: containerView!.bounds.height/2, width: containerView!.bounds.width, height: containerSize.height)
    }
    
    func dismissPresentedViewController(tap: UITapGestureRecognizer) {
        if tap.state == .Recognized {
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSizeMake(containerView!.bounds.width, containerView!.bounds.height/2)
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView!.bounds
        presentedView()?.frame = frameOfPresentedViewInContainerView()        
    }
    
    override func shouldPresentInFullscreen() -> Bool {
        return true
    }
    
    override func adaptivePresentationStyle() -> UIModalPresentationStyle {
        return UIModalPresentationStyle.OverFullScreen
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {return}
        
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0
        
        containerView.insertSubview(dimmingView, atIndex: 0)
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext) in
            
            self.dimmingView.alpha = 1
            }, completion: { (context:UIViewControllerTransitionCoordinatorContext) in
                
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator()?.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext) in
            
            self.dimmingView.alpha = 0
            
            }, completion: { (context:UIViewControllerTransitionCoordinatorContext) in
                
        })
    }
}
