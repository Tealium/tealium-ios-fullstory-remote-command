//
//  ContentView.swift
//  TealiumFullstorySample
//
//  Created by Tyler Rister on 10/4/22.
//

import SwiftUI

struct EventButton: View {
    let title: String
    let event: String
    let data: [String: Any]
    
    var body: some View {
        Button(action: {
            TealiumHelper.trackEvent(title: event, data: data)
        }, label: {
            Text(title)
                .frame(width: 200)
                .padding()
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .shadow(radius: 8)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.purple, lineWidth: 2))
        })
    
    }
}

struct ContentView: View {
    @State var uid: String = ""
    var body: some View {
        VStack {
            TextField("UID", text: $uid).textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200)
                .padding()
            EventButton(title: "Identify User", event: "identify_user", data: ["uid": uid, "email": "sample@domain.com", "phone": "9999999999"])
            EventButton(title: "Track Event", event: "tealiumSampleEvent", data: [:])
            EventButton(title: "Track Event With Data", event: "tealiumSampleEventWithData", data: ["cart_id": "12345", "product_id": "54321", "price": 5.99, "name": "SampleEvent", "category": ["label": "misc"]])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
