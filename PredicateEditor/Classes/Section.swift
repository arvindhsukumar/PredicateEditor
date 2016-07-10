//
//  Section.swift
//  Pods
//
//  Created by Arvindh Sukumar on 07/07/16.
//
//

import Foundation

public class Section {
    var title: String
    var keyPathDescriptors: [KeyPathDescriptor] = []
    var rows: [Row] = []

    public init(title: String, keyPaths: [KeyPathDescriptor]){
        self.title = title
        self.keyPathDescriptors = keyPaths
    }
}

extension Section {

}