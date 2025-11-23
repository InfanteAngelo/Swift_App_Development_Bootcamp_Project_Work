//
//  ColoreDinamicoMenu.swift
//  DoggoFinder
//
//  Created by Studente on 22/07/24.
//

import SwiftUI

struct ColoreDinamicoMenu: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
            content
                .foregroundColor(colorScheme == .dark ? Color.color2 : Color.color4)
        }
}
