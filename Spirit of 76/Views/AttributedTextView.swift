//
//  AttributedText.swift
//  Spirit of 76
//
//  Created by Tim W. Newton on 6/13/21.
//

//
import SwiftUI

struct AttributedTextBlock {
    let content: String
    let font: Font?
    let color: Color?
}

struct AttributedTextView: View {
    var attributedText: NSAttributedString?
    
    private var descriptions: [AttributedTextBlock] = []
    
    init(_ attributedText: NSAttributedString?) {
        self.attributedText = attributedText
        
        self.extractDescriptions()
    }
    
    private mutating func extractDescriptions()  {
        if let text = attributedText {
            text.enumerateAttributes(in: NSMakeRange(0, text.length), options: [], using: { (attribute, range, stop) in
                let substring = (text.string as NSString).substring(with: range)
                let font =  (attribute[.font] as? UIFont).map { Font.custom($0.fontName, size: $0.pointSize) }
                let color = (attribute[.foregroundColor] as? UIColor).map { Color($0) }
                descriptions.append(AttributedTextBlock(content: substring,
                                                        font: font,
                                                        color: color))
            })
        }
    }
    
    var body: some View {
        ScrollView {
            descriptions.map { description in
                Text(description.content)
                    .font(description.font)
            }.reduce(Text("")) { (result, text) in
                result + text
            }
        }
    }
}

struct AttributedText_Previews: PreviewProvider {
    static var previews: some View {
        AttributedTextView(DeclarationOfIndependence.shared.attributedString())
    }
}
