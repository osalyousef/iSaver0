

import SwiftUI

struct AddView: View {
    func configureNavigationBarAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var animate = false
    @Environment(\.dismiss) var dismiss
    
    var expenses: Expenses
    
    let types = ["Personal" , "Business"]
    var body: some View {
        
        NavigationStack {
            VStack {
                Form {
                    TextField("Name:" , text: $name)
                    Picker("Type" , selection: $type) {
                        ForEach(types , id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.palette)
                    TextField("Amount: $" , value: $amount , format: .currency(code: "USD"))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    
                }
            }
            .background(.linearGradient(colors: [.indigo, .blue], startPoint: .top, endPoint: .bottom))
            .scrollContentBackground(.hidden)
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                        HStack {
                            Spacer(minLength: 25)
                            Text("New expense")
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(.white)
                            Spacer(minLength: 30)
                            Button(action: {
                                let item = ExpensesItems(name: name, type: type, amount: amount)
                                expenses.items.append(item)
                                dismiss()
                                withAnimation {
                                    animate.toggle()
                                }
                            }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .foregroundStyle(.green)
                                    

                            }
                        }
                    }
                }
            
            .navigationBarBackButtonHidden()
        }
    }


}
#Preview {
    AddView(expenses: Expenses())
}
