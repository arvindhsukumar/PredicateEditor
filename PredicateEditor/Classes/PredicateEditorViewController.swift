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

public class PredicateEditorViewController: UIViewController {
    var sections: [Section] = []
    var sectionViews: [SectionView] = []
    private let stackViewController: StackViewController
    
    public convenience init(sections:[Section]) {
        self.init()
        self.sections = sections
    }

    init() {
        stackViewController = StackViewController()
        stackViewController.stackViewContainer.separatorViewFactory = StackViewContainer.createSeparatorViewFactory()
        super.init(nibName: nil, bundle: nil)
        edgesForExtendedLayout = .None
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
    }

    private func setupStackView(){
        addChildViewController(stackViewController)
        view.addSubview(stackViewController.view)
        stackViewController.view.snp_makeConstraints {
            make in
            make.edges.equalTo(view)
        }
        stackViewController.didMoveToParentViewController(self)
        stackViewController.stackViewContainer.scrollView.alwaysBounceVertical = true

        for section in sections {
            let sectionViewController = SectionViewController(section: section)
            stackViewController.addItem(sectionViewController)
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

public extension PredicateEditorViewController {
    public func predicates() throws -> [NSPredicate] {
        return try sections.map({ (section) -> NSPredicate in
            dump(try section.predicates())
            return try section.compoundPredicate()
        })
    }
}

