//
//  StateBarView.swift
//  cached
//
//  Created by Marc Krenn on 13.11.22.
//

import SwiftUI
import AsyncReactor
import Endpoints
import Combine

struct StateBarView<C: Call>: View {
    
    let state: AsyncLoad<C>
    let onTap: () -> ()
    
    @State private var cacheAge = ""
    @State private var showingErrorAlert = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .receive(on: RunLoop.main)
        .merge(with: Just(Date()))
    
    func getSourceString(_ source: HTTPSource) -> String {
        switch source {
        case .none: return "Placeholder"
        case .origin: return "Origin"
        case .cache: return "Cache"
        }
    }
    
    func getButtonLabelString(_ state: AsyncLoad<C>) -> String {
        state.error == nil ? "Reload" : "Retry"
    }
    
    func cacheAge(_ state: AsyncLoad<C>, currentDate: Date) -> String? {
        guard let date = state.response?.value(forHTTPHeaderField: "Date") else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        let cacheDate = formatter.date(from: date)
        
        guard let cacheDate = cacheDate else { return nil}
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .abbreviated
        let string = relativeFormatter.localizedString(for: cacheDate, relativeTo: Date())
        return string.contains("in 0 sec") ? "NOW" : state.source == .cache ? string.replacingOccurrences(of: "ago", with: "old") : string
        
        
    }
    
    var body: some View {
        
        HStack {
            
            Text("\(getSourceString(state.source))")
                .bold()
            
            Spacer()
            
            if state.isLoading {
                
                ProgressView()
                
            } else if state.source != .none {
                
                Button(action: onTap) {
                    Text(cacheAge.uppercased())
                        .monospacedDigit()
                        .bold()
                        .font(.caption)
                        .foregroundColor(.accentColor)
                        .onReceive(timer) { input in
                            cacheAge = cacheAge(state, currentDate: input) ?? "0 sec old"
                        }
                        .padding(.vertical, 2)
                        .padding(.horizontal, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(Color.accentColor, lineWidth: 1)
                                .background(Color.accentColor.opacity(0.1))
                        )
                }
            }
            
            if let error = state.error {
                Button(action: { showingErrorAlert.toggle() }) {
                    Text("\(error.localizedDescription.uppercased())")
                        .monospacedDigit()
                        .bold()
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(Color.red, lineWidth: 1)
                                .background(Color.red.opacity(0.1))
                        )
                }
                
                
            }
        }
        .lineLimit(1)
        .animation(.spring(), value: state.isLoading)
        .animation(.spring(), value: state.error?.localizedDescription)
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text("Error"), message: Text(state.error?.localizedDescription ?? ""), dismissButton: .default(Text("Close")))
        }
    }
}

//struct StateBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        StateBarView()
//    }
//}
