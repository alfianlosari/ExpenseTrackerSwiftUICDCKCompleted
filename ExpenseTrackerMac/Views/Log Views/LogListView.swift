//
//  LogListView.swift
//  ExpenseTrackerMac
//
//  Created by Alfian Losari on 27/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct LogListView: View {
    
    @State var logToEdit: ExpenseLog?
    @State var logToShare: ExpenseLog?
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @FetchRequest(
        entity: ExpenseLog.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)
        ]
    )
    private var result: FetchedResults<ExpenseLog>
    
    init(predicate: NSPredicate?, sortDescriptor: NSSortDescriptor) {
        let fetchRequest = NSFetchRequest<ExpenseLog>(entityName: ExpenseLog.entity().name ?? "ExpenseLog")
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        _result = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        ZStack {
            List {
                
                
                ForEach(result) { (log: ExpenseLog) in
                    VStack(spacing: 8) {
                        HStack(spacing: 16) {
                            Text(log.nameText)
                                .frame(minWidth: 0, maxWidth: .infinity)
                            Spacer()
                            Text(log.dateText)
                                .frame(minWidth: 0, maxWidth: .infinity)
                            Spacer()
                            Text(log.categoryText)
                                .frame(minWidth: 0, maxWidth: .infinity)
                            Spacer()
                            Text(log.amountText)
                                .frame(minWidth: 0, maxWidth: .infinity)
                        }
                        Divider()
                    }
                    .popover(
                        item: self.logToEdit == log ? self.$logToEdit : .init(
                            get: { nil }, set: { (_) in })
                    ) { (log: ExpenseLog) in
                        LogFormView(
                            logToEdit: log,
                            context: self.context,
                            name: log.name ?? "",
                            amount: log.amount?.doubleValue ?? 0,
                            category: Category(rawValue: log.category ?? "") ?? .food,
                            date: log.date ?? Date()
                        )
                    }
                    .onTapGesture {
                        self.logToEdit = log
                    }
                    .contextMenu {
                        Button(action: {
                            self.logToEdit = log
                        }) {
                            Text("Edit")
                        }
                        Button(action: {
                            self.context.delete(log)
                            try? self.context.saveContext()
                        }) {
                            Text("Delete")
                        }
                    }
                }
                .onDelete(perform: onDelete)
            }
            
            
            if result.isEmpty {
                Text("No expenses data\nPlease add your expenses from the logs tab")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(.horizontal)
            }
        }
            
            
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func onDelete(with indexSet: IndexSet) {
        indexSet.forEach { index in
            let log = result[index]
            context.delete(log)
        }
        try? context.saveContext()
    }
}


struct LogListView_Previews: PreviewProvider {
    static var previews: some View {
        let stack = CoreDataStack(modelName: "ExpenseTracker")
        let sortDescriptor = ExpenseLogSort(sortType: .date, sortOrder: .descending).sortDescriptor
        return LogListView(predicate: nil, sortDescriptor: sortDescriptor)
            .environment(\.managedObjectContext, stack.viewContext)
    }
}
