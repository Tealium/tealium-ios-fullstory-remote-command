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
            TealiumHelper.trackView(title: event, data: data)
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
            EventButton(title: "Identify User", event: "identify", data: ["uid": uid])
            EventButton(title: "Track Event", event: "tealiumSampleEvent", data: [:])
            EventButton(title: "Track Event With Data", event: "tealiumSampleEventWithData", data: ["sampleKey1": "sampleValue1", "sampleKey2": "sampleValue2"])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
