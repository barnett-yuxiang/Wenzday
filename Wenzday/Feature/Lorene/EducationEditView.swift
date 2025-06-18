//
//  EducationEditView.swift
//  Wenzday
//
//  Created by Assistant on 2025/6/17.
//

import SwiftUI

struct EducationEditView: View {
    @ObservedObject var profileManager: ProfileManager
    @Environment(\.dismiss) private var dismiss

    let editingEntry: EducationEntry?

    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var hasEndDate: Bool = false
    @State private var institution: String = ""
    @State private var level: String = ""

    private let commonLevels = [
        "Nursery",
        "Kindergarten",
        "Elementary Grade 1", "Elementary Grade 2", "Elementary Grade 3",
        "Elementary Grade 4", "Elementary Grade 5", "Elementary Grade 6",
        "Middle School Grade 7", "Middle School Grade 8",
        "Middle School Grade 9",
        "High School Grade 10", "High School Grade 11", "High School Grade 12",
        "Bachelor's Degree", "Master's Degree", "Doctoral Degree",
        "Other",
    ]

    private var isEditing: Bool {
        editingEntry != nil
    }

    private var navigationTitle: String {
        isEditing ? "Edit Education" : "Add Education"
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Time Information")) {
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        displayedComponents: .date
                    )

                    VStack(alignment: .leading) {
                        Toggle("Set End Date", isOn: $hasEndDate)

                        if hasEndDate {
                            DatePicker(
                                "End Date",
                                selection: $endDate,
                                displayedComponents: .date
                            )
                        } else {
                            Text("Present")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                }

                Section(header: Text("Education Information")) {
                    HStack {
                        Text("School")
                        TextField(
                            "e.g., Harvard University",
                            text: $institution
                        )
                        .multilineTextAlignment(.trailing)
                    }

                    Picker("Level", selection: $level) {
                        ForEach(commonLevels, id: \.self) { levelOption in
                            Text(levelOption).tag(levelOption)
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEducation()
                    }
                    .fontWeight(.semibold)
                    .disabled(level.isEmpty)
                }
            }
        }
        .onAppear {
            loadCurrentData()
        }
        .onChange(of: editingEntry) { oldValue, newValue in
            print("=== editingEntry changed ===")
            print("oldValue: \(oldValue?.institution ?? "nil")")
            print("newValue: \(newValue?.institution ?? "nil")")

            // Add a small delay to ensure state consistency
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                loadCurrentData()
            }
        }
    }

    private func loadCurrentData() {
        print("=== EducationEditView loadCurrentData ===")
        print("editingEntry: \(editingEntry?.institution ?? "nil")")

        if let entry = editingEntry {
            print("Loading existing entry: \(entry.institution), level: \(entry.level)")
            startDate = entry.startDate

            if let endDate = entry.endDate {
                self.endDate = endDate
                self.hasEndDate = true
            } else {
                self.hasEndDate = false
            }

            institution = entry.institution
            level = entry.level

            print("Loaded values - institution: '\(institution)', level: '\(level)'")
        } else {
            print("Creating new entry")
            // For new entries, set default level to first option
            level = commonLevels.first ?? ""
        }
    }

    private func saveEducation() {
        if let existingEntry = editingEntry {
            // Edit mode: update existing entry
            var updatedEntry = existingEntry
            updatedEntry.startDate = startDate
            updatedEntry.endDate = hasEndDate ? endDate : nil
            updatedEntry.institution = institution
            updatedEntry.level = level

            profileManager.updateEducationEntry(updatedEntry)
        } else {
            // Add mode: create new entry
            let newEntry = EducationEntry(
                startDate: startDate,
                endDate: hasEndDate ? endDate : nil,
                institution: institution,
                level: level
            )
            profileManager.addEducationEntry(newEntry)
        }

        dismiss()
    }
}
