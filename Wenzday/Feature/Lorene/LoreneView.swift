//
//  LoreneView.swift
//  Wenzday
//
//  Created by yuxiang on 2025/6/17.
//

import SwiftUI

struct LoreneView: View {
    @StateObject private var profileManager = ProfileManager()
    @State private var showingEditSheet = false
    @State private var showingEducationSheet = false
    @State private var editingEducation: EducationEntry?

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.pink.opacity(0.1), Color.orange.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if profileManager.isLoading {
                    ProgressView("Loading...")
                        .scaleEffect(1.2)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // 1. Avatar Section
                            avatarSection

                            // 2. Basic Information Section
                            basicInfoSection

                            // 3. Education History Section
                            educationSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingEditSheet) {
            ProfileEditView(profileManager: profileManager)
        }
        .sheet(isPresented: $showingEducationSheet) {
            EducationEditView(
                profileManager: profileManager,
                editingEntry: editingEducation
            )
        }
    }

    // MARK: - Avatar Section
    private var avatarSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.pink)
        }
        .padding(.top, 20)
    }

    // MARK: - Basic Information Section
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
                        HStack {
                Text("Basic Information")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                Button("Edit") {
                    showingEditSheet = true
                }
                .foregroundStyle(.pink)
            }

                        VStack(alignment: .leading, spacing: 12) {
                InfoRow(label: "Chinese Name", value: profileManager.profileData.chineseName.isEmpty ? "Not Set" : profileManager.profileData.chineseName)
                InfoRow(label: "English Name", value: profileManager.profileData.englishName.isEmpty ? "Not Set" : profileManager.profileData.englishName)

                InfoRow(label: "Birth Date", value: formatBirthDate(profileManager.profileData.birthDate))
                InfoRow(label: "Age", value: formatAge(profileManager.profileData.age))
                InfoRow(label: "Gender", value: profileManager.profileData.gender.displayName)
                InfoRow(label: "Email", value: profileManager.profileData.email.isEmpty ? "Not Set" : profileManager.profileData.email)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    // MARK: - Education History Section
    private var educationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
                        HStack {
                Text("Education History")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                Button("Add") {
                    editingEducation = nil
                    showingEducationSheet = true
                }
                .foregroundStyle(.pink)
            }

            if profileManager.profileData.educationHistory.isEmpty {
                Text("No education history")
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 20)
            } else {
                ForEach(profileManager.profileData.educationHistory.sorted(by: { $0.startDate > $1.startDate })) { education in
                    EducationRowView(
                        education: education,
                        onEdit: {
                            editingEducation = education
                            showingEducationSheet = true
                        },
                        onDelete: {
                            profileManager.deleteEducationEntry(education)
                        }
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    // MARK: - Helper Methods
        private func formatBirthDate(_ date: Date?) -> String {
        guard let date = date else { return "Not Set" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }

    private func formatAge(_ age: Int?) -> String {
        guard let age = age else { return "Not Set" }
        return "\(age) years old"
    }
}

// MARK: - Information Row View
struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)

            Text(value)
                .fontWeight(.medium)

            Spacer()
        }
    }
}

// MARK: - Education Row View
struct EducationRowView: View {
    let education: EducationEntry
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(education.dateRangeString)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(education.level)
                        .fontWeight(.medium)

                    if !education.institution.isEmpty {
                        Text(education.institution)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                                HStack(spacing: 16) {
                    Button("Edit") {
                        onEdit()
                    }
                    .foregroundStyle(.blue)

                    Button("Delete") {
                        onDelete()
                    }
                    .foregroundStyle(.red)
                }
                .font(.caption)
            }
        }
        .padding(.vertical, 8)
    }
}
