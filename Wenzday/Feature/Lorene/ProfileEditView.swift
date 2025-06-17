//
//  ProfileEditView.swift
//  Wenzday
//
//  Created by Assistant on 2025/6/17.
//

import SwiftUI

struct ProfileEditView: View {
    @ObservedObject var profileManager: ProfileManager
    @Environment(\.dismiss) private var dismiss

    @State private var chineseName: String = ""
    @State private var englishName: String = ""
    @State private var birthDate: Date = Date()
    @State private var hasBirthDate: Bool = false
    @State private var selectedGender: Gender = .notSpecified
    @State private var email: String = ""

    var body: some View {
        NavigationView {
                        Form {
                Section(header: Text("Basic Information")) {
                    // Chinese Name
                    HStack {
                        Text("Chinese Name")
                        TextField("Enter Chinese name", text: $chineseName)
                            .multilineTextAlignment(.trailing)
                    }

                    // English Name
                    HStack {
                        Text("English Name")
                        TextField("Enter English name", text: $englishName)
                            .multilineTextAlignment(.trailing)
                    }

                    // Birth Date
                    VStack(alignment: .leading) {
                        Toggle("Set Birth Date", isOn: $hasBirthDate)

                        if hasBirthDate {
                            DatePicker(
                                "Birth Date",
                                selection: $birthDate,
                                displayedComponents: .date
                            )
                        }
                    }

                    // Gender
                    Picker("Gender", selection: $selectedGender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.displayName).tag(gender)
                        }
                    }

                    // Email
                    HStack {
                        Text("Email")
                        TextField("Enter email address", text: $email)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                }
            }
            .navigationTitle("Edit Personal Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            loadCurrentData()
        }
    }

    private func loadCurrentData() {
        let profile = profileManager.profileData
        chineseName = profile.chineseName
        englishName = profile.englishName

        if let birthDate = profile.birthDate {
            self.birthDate = birthDate
            self.hasBirthDate = true
        } else {
            self.hasBirthDate = false
        }

        selectedGender = profile.gender
        email = profile.email
    }

    private func saveProfile() {
        profileManager.updateBasicInfo(
            chineseName: chineseName,
            englishName: englishName,
            birthDate: hasBirthDate ? birthDate : nil,
            gender: selectedGender,
            email: email
        )
        dismiss()
    }
}