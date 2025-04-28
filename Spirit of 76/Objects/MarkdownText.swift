//
//  MarkdownText.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 4/28/25.
//


import SwiftUI

struct MarkdownText {
    static private func markdownText(text:String) -> Text {
        if let md = try? AttributedString(markdown: text) {
            return Text(md)
        }
        else {
            return Text(text)
        }
    }
    
    static func textView(_ text:String) -> VStack<ForEach<[String.SubSequence], String.SubSequence, Text>> {
        let paragraphs = text.split(separator: "\n")
        
        return VStack (alignment: .leading, spacing: 5) {
            ForEach(paragraphs, id:\.self) { p in
                Self.markdownText(text: String(p))
            }
        }
    }
}