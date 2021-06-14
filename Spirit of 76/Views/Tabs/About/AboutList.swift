//
//  AboutList.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/12/21.
//

import SwiftUI
import StoreKit
import MessageUI

struct AboutList: View {
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    let recipients = ["support@software123.com"]
    let subject = "\(K.appName) Support"
    let messageBody = "<p>======<br/>App: \(K.appName).<br />Version: \(K.appVersion)<br />Please Do Not Remove<br/>======</p>"
    let messageBodyIsHtml = true
    
    var body: some View {
        List {
            Section(header: FeedbackSectionHeader()) {
                HStack {
                    Image(systemName: "star.circle")
                    Text("Rate Me")
                    Button("") {
                        SKStoreReviewController.requestReviewInCurrentScene()
                    }
                }
                HStack {
                    Image(systemName: "envelope.circle")
                    Text("Send Email")
                    Button("") {
                        self.isShowingMailView.toggle()
                    }
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(result: self.$result,
                                 recipients: self.recipients,
                                 subject: self.subject,
                                 messageBody: self.messageBody,
                                 messageBodyIsHtml: self.messageBodyIsHtml)
                    }
                }
            }
            Section(header: ApplicatonSectionHeader()) {
                HStack {
                    NavigationLink(destination: CreditsView()) {
                        Image(systemName: "book.circle")
                        Text("Credits")
                    }
                    .isDetailLink(true)
                }
                HStack {
                    NavigationLink(destination: AppInfoView()) {
                        Image(systemName: "info.circle")
                        Text("App Info")
                    }
                    .isDetailLink(true)
                }
            }
        }.listStyle(GroupedListStyle())
    }
}
