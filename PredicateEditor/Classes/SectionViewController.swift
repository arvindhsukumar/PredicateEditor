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
    var section: Section!
    var sectionView: SectionView!

    convenience init(section:Section){
        self.init(nibName: nil, bundle: nil)
        self.section = section
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
        print(view.frame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView(){
        sectionView = SectionView(frame: CGRectZero)
        sectionView.delegate = self
        sectionView.dataSource = self
        view.addSubview(sectionView)
        sectionView.snp_makeConstraints {
            make in
            make.edges.equalTo(view)
        }
        sectionView.reloadData()
    }
}

extension SectionViewController: SectionDelegate, SectionDataSource {
    func sectionViewTitle() -> String {
        return "test"
    }

    func sectionViewNumberOfRows() -> Int {
        return 2
    }

    func sectionViewRowForItemAtIndex(index: Int) -> UIView {
        let view = UIView(frame: CGRectMake(0,0,200,100))
        view.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.text = "Item \(index)"
        view.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.edges.equalTo(view).inset(10).priority(990)
        }
        view.backgroundColor = UIColor.redColor()

        return view
    }
}