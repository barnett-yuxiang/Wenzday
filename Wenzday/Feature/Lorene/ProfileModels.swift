//
//  ProfileModels.swift
//  Wenzday
//
//  Created by Assistant on 2025/6/17.
//

import Foundation

// MARK: - Personal Profile Data Model
struct ProfileData: Codable {
    var chineseName: String = ""
    var englishName: String = ""
    var birthDate: Date? = nil
    var gender: Gender = .notSpecified
    var email: String = ""
    var educationHistory: [EducationEntry] = []

    // Calculate age based on birth date
    var age: Int? {
        guard let birthDate = birthDate else { return nil }
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents(
            [.year],
            from: birthDate,
            to: now
        )
        return ageComponents.year
    }
}

// MARK: - Gender Enumeration
enum Gender: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    case notSpecified = "Not Specified"

    var displayName: String {
        return self.rawValue
    }
}

// MARK: - Education Entry Model
struct EducationEntry: Codable, Identifiable {
    let id: UUID
    var startDate: Date
    var endDate: Date?
    var institution: String
    var level: String  // e.g., Elementary Grade 1, Middle School, High School, University

    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date? = nil,
        institution: String,
        level: String
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.institution = institution
        self.level = level
    }

    // Format date range for display
    var dateRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        formatter.locale = Locale(identifier: "en_US")

        let startString = formatter.string(from: startDate)
        if let endDate = endDate {
            let endString = formatter.string(from: endDate)
            return "\(startString) - \(endString)"
        } else {
            return "\(startString) - Present"
        }
    }
}
