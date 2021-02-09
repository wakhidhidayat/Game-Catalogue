//
//  Util.swift
//  GameCatalogue
//
//  Created by Wahid Hidayat on 09/02/21.
//  Copyright © 2021 Wakhid Saiful Hidayat. All rights reserved.
//

import Foundation

class Util {
    static func formatDate(from dateString: String) -> String? {
        let date = dateString.convertDateString()
        if let date = date {
            return date.convertToString()
        }
        return nil
    }
    
    static func removeHTMLTags(in overview: String) -> String? {
        overview.trimHTMLTags()
    }
}

extension String {
    func convertDateString() -> Date? {
        return convert(dateString: self, fromDateFormat: "yyyy-MM-dd", toDateFormat: "dd-MM-yyyy")
    }

    func convert(dateString: String, fromDateFormat: String, toDateFormat: String) -> Date? {
        let fromDateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = fromDateFormat

        if let fromDateObject = fromDateFormatter.date(from: dateString) {
            let toDateFormatter = DateFormatter()
            toDateFormatter.dateFormat = toDateFormat
            return fromDateObject
        }
        return nil
    }
    
    func trimHTMLTags() -> String? {
        guard let htmlStringData = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let attributedString = try? NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil)
        return attributedString?.string
    }
}

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: self)
    }
}
