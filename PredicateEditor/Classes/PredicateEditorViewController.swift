//
//  PredicateEditorViewController.swift
//  Pods
//
//  Created by Arvindh Sukumar on 07/07/16.
//
//

import UIKit
import StackViewController
import SnapKit

public struct PredicatorEditorConfig {
    public var keyPathDisplayColor: UIColor!
    public var comparisonButtonColor: UIColor!
    public var inputColor: UIColor!
    public var backgroundColor: UIColor!
    public var sectionBackgroundColor: UIColor!
    public var errorColor: UIColor!
    
    public init() {
        self.keyPathDisplayColor = UIColor(red:0.64, green:0.41, blue:0.65, alpha:1.00)
        self.comparisonButtonColor = UIColor(red:0.27, green:0.47, blue:0.74, alpha:1.00)
        self.inputColor = UIColor(red:0.00, green:0.53, blue:0.19, alpha:1.00)
        self.backgroundColor = UIColor(red:0.87, green:0.89, blue:0.93, alpha:1.00)
        self.sectionBackgroundColor = UIColor(red:0.94, green:0.95, blue:0.97, alpha:1.00)
        self.errorColor = UIColor(red:0.44, green:0.15, blue:0.20, alpha:1.00)
    }
}

@objc public protocol PredicateEditorDelegate {
    func predicateEditorDidFinishWithPredicates(predicates: [NSPredicate])
}

public class PredicateEditorViewController: UIViewController {
    public weak var delegate: PredicateEditorDelegate?
    var config: PredicatorEditorConfig!
    var sections: [Section] = []
    var sectionViews: [SectionView] = []
    private let stackViewController: StackViewController
    
    public convenience init(sections:[Section], config: PredicatorEditorConfig = PredicatorEditorConfig() ) {
        self.init()
        self.sections = sections
        self.config = config
    }
    
    init() {
        stackViewController = StackViewController()
        stackViewController.stackViewContainer.separatorViewFactory = StackViewContainer.createSeparatorViewFactory()
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(PredicateEditorViewController.dismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(PredicateEditorViewController.createPredicateAndDismiss))
        
        edgesForExtendedLayout = .None
        setupStackView()
    }

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.translucent = false
    }
    
    private func setupStackView(){
        stackViewController.view.backgroundColor = config.backgroundColor
        addChildViewController(stackViewController)
        view.addSubview(stackViewController.view)
        stackViewController.view.snp_makeConstraints {
            make in
            make.edges.equalTo(view)
        }
        stackViewController.didMoveToParentViewController(self)
        stackViewController.stackViewContainer.scrollView.alwaysBounceVertical = true

        for section in sections {
            let sectionViewController = SectionViewController(section: section, config: config)
            stackViewController.addItem(sectionViewController)
        }
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createPredicateAndDismiss() {
        do {
            try delegate?.predicateEditorDidFinishWithPredicates(predicates())
            dismiss()
        }
        catch RowPredicateError.InsufficientData(keyPath: let keyPath) {
            var message: String = "Please update all filters"
            if let kp = keyPath {
                message = "Please update value for \"\(kp.title)\""
            }
            showErrorToast(message)
        }
        catch {
            print("error")
        }
    }
    
    private func showErrorToast(message: String){
        navigationItem.rightBarButtonItem?.enabled = false
        let toast = ErrorToastView(message: message)
        toast.backgroundColor = config.errorColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PredicateEditorViewController.dismissToastOnTap(_:)))
        
        var toastTopConstraint: Constraint!
        view.addSubview(toast)
        toast.snp_makeConstraints { (make) in
            make.left.equalTo(view)
            make.right.equalTo(view)
            toastTopConstraint = make.top.equalTo(view.snp_bottom).constraint
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            toastTopConstraint.updateOffset(-toast.frame.size.height)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()

            }) { (finished) in
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
                
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.hideErrorToast(toast)
                }
        }
    }
    
    func dismissToastOnTap(gesture: UITapGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Recognized {
            hideErrorToast(gesture.view as! ErrorToastView)
        }
    }
    
    private func hideErrorToast(toast: ErrorToastView){
        var frame = toast.frame
        UIView.animateWithDuration(0.25, animations: {
            frame.origin.y = self.view.frame.size.height
            toast.frame = frame
        }) { (finished: Bool) in
            toast.removeFromSuperview()
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

public extension PredicateEditorViewController {
    public func predicates() throws -> [NSPredicate] {
        let predicates = try sections.map({ (section) -> NSPredicate in
            dump(try section.predicates())
            print(section.compoundPredicateType)
            return try section.compoundPredicate()
        })
        
        return predicates.filter({ (predicate:NSPredicate) -> Bool in
            return !predicate.isEmpty
        })
    }
}

