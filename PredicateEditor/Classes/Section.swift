//
//  Section.swift
//  Pods
//
//  Created by Arvindh Sukumar on 07/07/16.
//
//

import Foundation

@objc protocol SectionDelegate {
    optional func didAddRow(row: Row)
    optional func didDeleteRow(row: Row)
}

public class Section {
    var title: String
    var keyPathDescriptors: [KeyPathDescriptor] = []
    var rows: [Row] = []
    weak var delegate: SectionDelegate?

    public init(title: String, keyPaths: [KeyPathDescriptor]){
        self.title = title
        self.keyPathDescriptors = keyPaths
    }
}

extension Section {

}