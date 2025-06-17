//
//  ProfileManager.swift
//  Wenzday
//
//  Created by Assistant on 2025/6/17.
//

import Foundation

// MARK: - Profile Data Storage Manager
@MainActor
class ProfileManager: ObservableObject {
    @Published var profileData: ProfileData = ProfileData()
    @Published var isLoading: Bool = false

    private let fileName = "profile_data.json"

    init() {
        loadProfileData()
    }

    // MARK: - File Path Management
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    private var documentsFileURL: URL {
        documentsDirectory.appendingPathComponent(fileName)
    }

    private var bundleFileURL: URL? {
        Bundle.main.url(forResource: "profile_data", withExtension: "json")
    }

    // MARK: - Async Load Profile Data
    func loadProfileData() {
        isLoading = true

        Task {
            do {
                var data: Data

                // First try to load from Documents directory (user's modified data)
                if FileManager.default.fileExists(atPath: documentsFileURL.path) {
                    data = try Data(contentsOf: documentsFileURL)
                    print("Loading profile data from Documents directory")
                }
                // If not found, load from app bundle (preset data)
                else if let bundleURL = bundleFileURL {
                    data = try Data(contentsOf: bundleURL)
                    print("Loading preset profile data from app bundle")
                }
                // If neither exists, use default empty data
                else {
                    throw NSError(domain: "ProfileManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "No profile data found"])
                }

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                // Debug: Print the raw JSON string
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON data: \(jsonString.prefix(200))...") // Print first 200 chars
                }

                let loadedProfile = try decoder.decode(ProfileData.self, from: data)

                await MainActor.run {
                    self.profileData = loadedProfile
                    self.isLoading = false
                }
            } catch {
                // If all fails, use default empty data
                print("Failed to load profile data: \(error.localizedDescription)")
                if let decodingError = error as? DecodingError {
                    print("Decoding error details: \(decodingError)")
                }
                await MainActor.run {
                    self.profileData = ProfileData()
                    self.isLoading = false
                }
            }
        }
    }

    // MARK: - Save Profile Data
    func saveProfileData() {
        Task {
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                encoder.outputFormatting = .prettyPrinted

                let data = try encoder.encode(profileData)
                try data.write(to: documentsFileURL)

                print("Profile data saved successfully to Documents directory")
            } catch {
                print("Failed to save profile data: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Update Basic Info
    func updateBasicInfo(
        chineseName: String? = nil,
        englishName: String? = nil,
        birthDate: Date? = nil,
        gender: Gender? = nil,
        email: String? = nil
    ) {
        if let chineseName = chineseName {
            profileData.chineseName = chineseName
        }
        if let englishName = englishName {
            profileData.englishName = englishName
        }
        if let birthDate = birthDate {
            profileData.birthDate = birthDate
        }
        if let gender = gender {
            profileData.gender = gender
        }
        if let email = email {
            profileData.email = email
        }

        saveProfileData()
    }

    // MARK: - Education History Management
    func addEducationEntry(_ entry: EducationEntry) {
        profileData.educationHistory.append(entry)
        saveProfileData()
    }

    func updateEducationEntry(_ entry: EducationEntry) {
        if let index = profileData.educationHistory.firstIndex(where: { $0.id == entry.id }) {
            profileData.educationHistory[index] = entry
            saveProfileData()
        }
    }

    func deleteEducationEntry(_ entry: EducationEntry) {
        profileData.educationHistory.removeAll { $0.id == entry.id }
        saveProfileData()
    }
}