//
//  SearchBar.swift
//  DoggoFinder
//
//  Created by Studente on 07/07/24.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    
    
    @Binding var text: String
    @Binding var buttonCancelButton: Bool
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        @Binding var buttonCancelButton: Bool
        
        init(text: Binding<String>, buttonCancelButton: Binding<Bool>) {
            _text = text
            _buttonCancelButton = buttonCancelButton
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            buttonCancelButton = true
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            buttonCancelButton = false
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, buttonCancelButton: $buttonCancelButton)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search"
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
        
    }
     
}
