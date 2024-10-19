import SwiftUI

struct ContentView: View {
    @State var cardHolderName: String = ""
    @State var bank: String = ""
    @State var bankname: String = "VISA"
    @State var cardnumber: String = ""
    @State var cvv: String = ""
    @State var selectedDate = Date()
    @State var selectedColor: Color = Colors.blue
    @State var rawCardNumber: String = ""
    @State var formattedCardNumber: String = ""
    @State var rawCVV: String = ""
    @State var formattedCVV: String = ""
    @State var isShowingSheet: Bool = false
    
    let banknames = ["VISA", "Discover", "AMEX", "Mastercard"]
    
    var body: some View {
        Text("Add Card")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.black)
        Form {
            Section("SIGNATURE") {
                TextField("Card Holder Name", text: $cardHolderName)
                TextField("Bank", text: $bank)
                
                Picker("Card Type", selection: $bankname) {
                    ForEach(banknames, id: \.self) { bankname in
                        Text(bankname).tag(bankname)
                    }
                }
                .pickerStyle(.automatic)
            }
            Section("DETAILS") {
                TextField("Card Number", text: $formattedCardNumber)
                    .keyboardType(.numberPad)
                    .onChange(of: formattedCardNumber) { newValue in
                        rawCardNumber = newValue.filter { "0123456789".contains($0) }
                        if (rawCardNumber.count > 16) {
                            rawCardNumber = String(rawCardNumber.prefix(16))
                        }
                        formattedCardNumber = formatCardNumber(rawCardNumber)
                    }
                
                TextField("CVV", text: $formattedCVV)
                    .keyboardType(.numberPad)
                    .onChange(of: formattedCVV) { newValue in
                        rawCVV = newValue.filter { "0123456789".contains($0) }
                        if (rawCVV.count > 3) {
                            rawCVV = String(rawCVV.prefix(3))
                        }
                        formattedCVV = rawCVV
                    }
                
                HStack {
                    Text("Valid Through")
                        .font(.subheadline)
                    Spacer()
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }
            }
            
            Section("CARD COLOR") {
                Picker("Select a Color", selection: $selectedColor) {
                    Text("Blue").tag(Colors.blue)
                    Text("Black").tag(Colors.black)
                    Text("Red").tag(Colors.red)
                    Text("Green").tag(Colors.green)
                }
                .pickerStyle(.segmented)
            }
            Button("Add Card to Wallet") {
                isShowingSheet.toggle()
            }
            .foregroundColor(.blue)
        }
        .sheet(isPresented: $isShowingSheet) {
            ScrollView {
                VStack {
                    ZStack {
                        selectedColor
                            .cornerRadius(10)
                            .frame(height: 200)
                            .padding()
                            .shadow(radius: 5)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(bank.isEmpty ? "ENTER BANK NAME" : bank.uppercased())
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                Text(bankname)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 10)
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                            
                            Spacer()
                            Spacer()
                            
                            Text(formattedCardNumber.isEmpty ? "0000 0000 0000 0000" : formattedCardNumber)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Valid Through")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    Text(formattedDate())
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                VStack(alignment: .leading) {
                                    Text("CVV: \(rawCVV.isEmpty ? "***" : formattedCVV)")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal)
                            
                            Text(cardHolderName.isEmpty ? "CARDHOLDER NAME" : cardHolderName.uppercased())
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
    
    func formatCardNumber(_ number: String) -> String {
        var formattedNumber = ""
        var count = 0
        
        for char in number {
            if char.isNumber {
                if count > 0 && count % 4 == 0 {
                    formattedNumber += " "
                }
                formattedNumber += String(char)
                count += 1
            }
        }
        return formattedNumber
    }

    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        return dateFormatter.string(from: selectedDate)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
