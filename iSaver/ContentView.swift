import SwiftUI
struct ExpensesItems: Identifiable, Codable , Equatable {
    let name: String
    let type: String
    let amount: Double
    var id = UUID()
}

@Observable
class Expenses {
    var items = [ExpensesItems]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }

    }
    var personalItems: [ExpensesItems] {
        items.filter { $0.type == "Personal" }
    }

    var businessItems: [ExpensesItems] {
        items.filter { $0.type == "Business" }
    }

    init() {
        if let saved = UserDefaults.standard.data(forKey: "Items") {
            if let decoded = try? JSONDecoder().decode([ExpensesItems].self, from: saved) {
                items = decoded
                return
            }
        }
        items = []
    }
    
}

struct ContentView: View {
    init() {
     // Large Navigation Title
     UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
     // Inline Navigation Title
     UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
   }
    @State private var expenses = Expenses()
    @State private var showAdd = false

    var body: some View {
        
        NavigationStack {
            List {
                // Personal Expenses Section
                Section(header: Text("Personal Expenses").foregroundStyle(.white)) {
                    ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            formattedAmountText(for: item.amount)
                        }
                        
                    }
                    .onDelete(perform: removePersonalItems)
                }
                
                // Business Expenses Section
                Section(header: Text("Business Expenses").foregroundStyle(.white)) {
                    ForEach(expenses.items.filter { $0.type == "Business" }) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                
                                Text(item.type)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            formattedAmountText(for: item.amount)
                        }
                    }
                    .onDelete(perform: removeBusinessItems)
                }
            }
                .background(.linearGradient(colors: [.blue, .gray], startPoint: .top, endPoint: .bottom))
                .scrollContentBackground(.hidden)
                .navigationTitle("iSaver")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        VStack(alignment: .center) {
                            NavigationLink(destination: AddView(expenses: expenses)) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
        }
    
    func removeItems(at offsets: IndexSet, in inputArray: [ExpensesItems]) {
        var objectsToDelete = IndexSet()

        for offset in offsets {
            let item = inputArray[offset]

            if let index = expenses.items.firstIndex(of: item) {
                objectsToDelete.insert(index)
            }
        }
        expenses.items.remove(atOffsets: objectsToDelete)
    }
    func removePersonalItems(at offsets: IndexSet) {
        removeItems(at: offsets , in: expenses.personalItems)
    }

       // Function to remove business items
       func removeBusinessItems(at offsets_: IndexSet) {
           removeItems(at: offsets_, in: expenses.businessItems)
           }
       
    func formattedAmountText(for item: Double) -> Text {
        let amount = item
        let currencyCode = Locale.current.currency?.identifier ?? "USD"
        
        if amount >= 1000 && amount > 100 {
            return Text(amount, format: .currency(code: currencyCode))
                .foregroundStyle(Color.red)
        } else if amount >= 100 && amount < 1000 {
            return Text(amount, format: .currency(code: currencyCode))
                .foregroundStyle(Color.blue)
        } else if amount >= 0 && amount < 100 {
            return Text(amount, format: .currency(code: currencyCode))
                .foregroundStyle(Color.gray)
        } else {
            // Handle other cases if needed
            return Text("Invalid amount")
        }
    }

}

#Preview {
    ContentView()
}
