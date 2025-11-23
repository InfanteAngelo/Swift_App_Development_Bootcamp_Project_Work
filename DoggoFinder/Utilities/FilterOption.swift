//
//  FilterOption.swift
//  DoggoFinder
//
//  Created by Studente on 20/07/24.
//

import SwiftUI

enum FilterOption: String, CaseIterable, Identifiable {
    case città = "Città", razza = "Razza del cane"
    var id: Self {self}
}
