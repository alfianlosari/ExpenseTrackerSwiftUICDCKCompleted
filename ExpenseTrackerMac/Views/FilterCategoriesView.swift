//
//  SelectSortOrderView.swift
//  ExpenseTrackerMac
//
//  Created by Alfian Losari on 28/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct FilterCategoriesView: View {
    
    @Binding var selectedCategories: Set<Category>
    private let categories = Category.allCases
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(categories) { category in
                    FilterButtonView(
                        category: category,
                        isSelected: self.selectedCategories.contains(category),
                        onTap: self.onTap
                    )
                        .padding(.leading, category == self.categories.first ? 16 : 0)
                        .padding(.trailing, category == self.categories.last ? 16 : 0)
                }
            }
        }
    }
    
    func onTap(category: Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}

struct FilterButtonView: View {
    
    var category: Category
    var isSelected: Bool
    var onTap: (Category) -> ()
    
    var body: some View {
        
        HStack(spacing: 4) {
            Text(category.rawValue.capitalized)
                .fixedSize(horizontal: true, vertical: true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? category.color : Color.gray, lineWidth: 1))
            .frame(height: 44)
            .onTapGesture {
                self.onTap(self.category)
        }
        .foregroundColor(isSelected ? category.color : Color.gray)
    }
}

struct FilterCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        FilterCategoriesView(selectedCategories: .constant(Set()))
    }
}

