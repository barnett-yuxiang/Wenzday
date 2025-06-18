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
                    colors: [
                        Color.pink.opacity(0.1), Color.orange.opacity(0.2),
                    ],
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
                        .padding(.horizontal, 12)
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
            let capturedValue = editingEducation
            print(
                "=== Sheet creation - captured value: \(capturedValue?.institution ?? "nil")"
            )

            return EducationEditView(
                profileManager: profileManager,
                editingEntry: capturedValue
            )
            .onAppear {
                print("=== Sheet opened ===")
                print(
                    "editingEducation: \(editingEducation?.institution ?? "nil")"
                )
            }
        }
    }

    // MARK: - Avatar Section
    private var avatarSection: some View {
        VStack(spacing: 12) {
            if UIImage(named: "avatar_lorene") != nil {
                Image("avatar_lorene")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.pink)
            }
        }
        .padding(.top, 20)
    }

    // MARK: - Basic Information Section
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Basic Information")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                Button("Edit") {
                    showingEditSheet = true
                }
                .foregroundStyle(.pink)
                .font(.subheadline)
            }

            VStack(alignment: .leading, spacing: 10) {
                InfoRow(
                    label: "Chinese Name",
                    value: profileManager.profileData.chineseName.isEmpty
                        ? "Not Set" : profileManager.profileData.chineseName
                )
                InfoRow(
                    label: "English Name",
                    value: profileManager.profileData.englishName.isEmpty
                        ? "Not Set" : profileManager.profileData.englishName
                )

                InfoRow(
                    label: "Birth Date",
                    value: formatBirthDate(profileManager.profileData.birthDate)
                )
                InfoRow(
                    label: "Age",
                    value: formatAge(profileManager.profileData.age)
                )
                InfoRow(
                    label: "Gender",
                    value: profileManager.profileData.gender.displayName
                )
                InfoRow(
                    label: "Email",
                    value: profileManager.profileData.email.isEmpty
                        ? "Not Set" : profileManager.profileData.email
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    // MARK: - Education History Section
    private var educationSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Education History")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                Button("Add") {
                    handleAddEducation()
                }
                .foregroundStyle(.pink)
                .font(.subheadline)
            }

            if profileManager.profileData.educationHistory.isEmpty {
                Text("No education history")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 20)
            } else {
                // Use List instead of LazyVStack for better swipe actions support
                List {
                    ForEach(
                        Array(
                            profileManager.profileData.educationHistory.sorted(
                                by: { $0.startDate > $1.startDate })
                                .enumerated()
                        ),
                        id: \.element.id
                    ) { index, education in
                        VStack(spacing: 0) {
                            EducationRowView(education: education)
                                .onTapGesture {
                                    print(
                                        "Tapped education: \(education.institution)"
                                    )
                                }
                                .swipeActions(edge: .trailing) {
                                    Button("Delete") {
                                        print(
                                            "Delete tapped for: \(education.institution)"
                                        )
                                        profileManager.deleteEducationEntry(
                                            education
                                        )
                                    }
                                    .tint(.red)

                                    Button("Edit") {
                                        print(
                                            "Edit tapped for: \(education.institution)"
                                        )
                                        handleEditEducation(education)
                                    }
                                    .tint(.blue)
                                }

                            // Add divider between items (except last)
                            if index < profileManager.profileData
                                .educationHistory.count - 1
                            {
                                Divider()
                                    .background(Color.gray.opacity(0.3))
                            }
                        }
                        .listRowSeparator(.hidden)  // Hide default separators to use custom ones
                        .listRowBackground(Color.clear)  // Transparent background
                        .listRowInsets(EdgeInsets())  // Remove default List row insets
                    }
                }
                .listStyle(.plain)  // Remove default List styling
                .frame(
                    height: CGFloat(
                        profileManager.profileData.educationHistory.count * 80
                    )
                )  // Fixed height
                .scrollDisabled(true)  // Disable List scrolling since we're in ScrollView
                .onAppear {
                    print(
                        "Education history loaded: \(profileManager.profileData.educationHistory.count) items"
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
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
        return "\(age)"
    }

    private func handleEditEducation(_ education: EducationEntry) {
        print("=== handleEditEducation called ===")
        print("Education to edit: \(education.institution)")

        // Set the editing state and show sheet with the specific education
        editingEducation = education
        print(
            "editingEducation set to: \(editingEducation?.institution ?? "nil")"
        )

        // Show the sheet immediately - the value is already set
        showingEducationSheet = true
        print("showingEducationSheet set to true")
    }

    private func handleAddEducation() {
        print("=== handleAddEducation called ===")

        // Clear the editing state for new entry
        editingEducation = nil
        print("editingEducation set to nil for new entry")

        // Show the sheet immediately
        showingEducationSheet = true
        print("showingEducationSheet set to true")
    }
}

// MARK: - Information Row View
struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 130, alignment: .leading)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()

            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}

// MARK: - Education Row View
struct EducationRowView: View {
    let education: EducationEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Top: Time range
            Text(education.dateRangeString)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)

            // Bottom: Institution (left) and Level (right)
            HStack {
                Text(
                    education.institution.isEmpty
                        ? "Not Set" : education.institution
                )
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
                .truncationMode(.tail)

                Spacer()

                Text(education.level)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}
