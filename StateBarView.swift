//
//  StateBarView.swift
//  cached
//
//  Created by Marc Krenn on 13.11.22.
//

import SwiftUI
import AsyncReactor
import SDWebImageSwiftUI
import Endpoints
import Combine

struct StateBarView<T>: View {
    
    let state: AsyncLoad<T>
    let onTap: () -> ()
    
    @State private var cacheAge = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .receive(on: RunLoop.main)
        .merge(with: Just(Date()))
    
    func getSourceString(_ source: HttpSource) -> String {
        switch source {
        case .none: return "None"
        case .origin: return "Origin"
        case .cache: return "Cache"
        }
    }
    
//    func getStateString(_ state: AsyncLoad<T>) -> String {
//
//        if let error = state.error {
//            return error.localizedDescription
//        }
//
//        return state.isLoading ? "Loading" : "Loaded"
//
//    }
    
    func getButtonLabelString(_ state: AsyncLoad<T>) -> String {
        state.error == nil ? "Reload" : "Retry"
    }
    
    func cacheAge(_ state: AsyncLoad<T>, currentDate: Date) -> String? {
        let date = state.response?.allHeaderFields.first { key, value in
            return key == "Date" as AnyHashable
        }
        guard let date = date?.value as? String else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        let cacheDate = formatter.date(from: date)
        
        guard let cacheDate = cacheDate else { return nil}
        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.unitsStyle = .abbreviated
        var string = relativeFormatter.localizedString(for: cacheDate, relativeTo: Date())
        return string.contains("in 0 sec") ? "NOW" : state.source == .cache ? string.replacingOccurrences(of: "ago", with: "old") : string


    }
    
    var body: some View {
        HStack() {
            Text("\(state.error == nil ? "Source:" : "Error:")")
                .bold()
            
            if let error = state.error {

                Text("\(error.localizedDescription)")
                    
            } else {
                Text("\(getSourceString(state.source))")
            }
            
            if state.error == nil && !state.isLoading {
                
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
            
            Spacer()
            
            Button(action: onTap) {

                if state.isLoading {
                    ActivityIndicator(.constant(true), style: .medium)
                } else {
                    Text("\(getButtonLabelString(state))")
                }
            }
            .buttonStyle(.bordered)
            
        }
        .lineLimit(1)
        .padding(.horizontal)
        .padding(.vertical, 15)
        .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color(uiColor: .separator)), alignment: .top)
        .background(Color(uiColor: .systemBackground)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 0)
        )
        .animation(.spring(), value: state.isLoading)
    }
}

//struct StateBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        StateBarView()
//    }
//}
