//
//  ContentView.swift
//  ExpenseTrackerMac
//
//  Created by Alfian Losari on 27/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Main Menu")) {
                    NavigationLink(destination: LogView(isShowingFilter: true, isShowingSort: true)
                    .environment(\.managedObjectContext, self.context)
                    ) {
                        Text("All Expenses")
                    }
                    
                    NavigationLink(destination: DashboardView()
                    ) {
                        Text("Dashboard")
                    }
                }
                Section(header: Text("Categories")) {
                    ForEach(Category.allCases) { category in
                        NavigationLink(destination: LogView(selectedCategories: Set(arrayLiteral: category)).environment(\.managedObjectContext, self.context)
                        ) {
                            Text(category.rawValue.capitalized)
                        }
                    }
                }
            }.listStyle(SidebarListStyle())
            
            LogView(isShowingFilter: true, isShowingSort: true)
                .environment(\.managedObjectContext, self.context)
        }
    }
}

struct DetailView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
