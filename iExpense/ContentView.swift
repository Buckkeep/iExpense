//
//  ContentView.swift
//  iExpense
//
//  Created by Buhecha, Neeta (Trainee Engineer) on 21/05/2024.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    
    @State var expenses = Expenses()
    
    @State var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    listItems(expenses: expenses, type: "Personal")
                }
                
                Section("Business") {
                    listItems(expenses: expenses, type: "Business")
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                    NavigationLink("Add Expense", destination: AddView(expenses: $expenses))
            }
            

            }
        }
    
    
    func removeItems(at offsets: IndexSet ) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func listItems(expenses: Expenses, type: String) -> some View {
        ForEach(expenses.items) { item in
            if item.type == type {
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        
                        Text(item.type)
                    }
                    
                    Spacer()
                    
                    Text(item.amount, format: .currency(code:Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle((item.amount <= 10) ? .green : (item.amount > 10 && item.amount < 100) ? .orange : .red)
                }
            }
        }
        .onDelete(perform: removeItems)
    }
    
}

#Preview {
    ContentView()
}
