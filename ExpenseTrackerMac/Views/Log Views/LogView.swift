//
//  LogView.swift
//  ExpenseTrackerMac
//
//  Created by Alfian Losari on 27/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct LogView: View {
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @State var isShowingFilter = false
    @State var isShowingSort = false
    @State var selectedCategories: Set<Category> = Set()
    
    @State private var isAddPresented: Bool = false
    @State private var searchText : String = ""
    @State private var sortType = SortType.date
    @State private var sortOrder = SortOrder.descending
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.isAddPresented = true
                }) {
                    Text("Add Log")
                }
                .popover(isPresented: $isAddPresented) {
                    LogFormView(context: self.context)
                }
                
                Spacer()
                Button(action: self.exportAsCSV) {
                    Text("Export as CSV")
                }
                
                TextField("Search expenses", text: self.$searchText)
                    .frame(width: 200)
            }
            .padding(.top, 8)
            .padding(.horizontal)
            
            if isShowingFilter {
                FilterCategoriesView(selectedCategories: self.$selectedCategories)
            }
            
            if isShowingSort {
                SelectSortOrderView(sortType: self.$sortType, sortOrder: self.$sortOrder)
            }
            
            LogListView(predicate: ExpenseLog.predicate(with: Array(self.selectedCategories), searchText: self.searchText), sortDescriptor: ExpenseLogSort(sortType: self.sortType, sortOrder: self.sortOrder).sortDescriptor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func exportAsCSV() {
        let fetchRequest = NSFetchRequest<ExpenseLog>(entityName: ExpenseLog.entity().name ?? "ExpenseLog")
        let sortDescriptor = ExpenseLogSort(sortType: self.sortType, sortOrder: self.sortOrder).sortDescriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let predicate = ExpenseLog.predicate(with: Array(self.selectedCategories), searchText: self.searchText) {
            fetchRequest.predicate = predicate
        }
        
        guard let result = try? self.context.fetch(fetchRequest) else {
            return
        }
        
        let csvs = result.map { $0.csvString }.joined(separator: "\n")
        let csv = "name , date , category , amount\n" + csvs
        let data = csv.data(using: .utf8)!
        NSSavePanel.saveCSV(data)
        
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
