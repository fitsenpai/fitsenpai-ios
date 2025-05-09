//
//  FeedbackEntityDataStore.swift
//  FitSenpai
//
//  Created by Mark Daquis on 5/2/25.
//

import SwiftUI
import SwiftData
import OSLog

final class ProfileDataStore: SwiftDataStore<UserProfileEntity> {
    
    func getCurrentProfile() -> UserProfileEntity? {
        return items.first
    }
    
    func getProfileByID(_ id: String) -> UserProfileEntity? {
        return items.first(where: { $0.id == id })
    }
    
    func getNewOrExistingProfile(_ profile: UserProfile) -> UserProfileEntity {
        let existingEntity = items.first(where: { $0.id == profile.id })
        return existingEntity ?? profile.toEntity()
    }
    
    func addProfile(_ profile: UserProfileEntity) -> UserProfileEntity? {
        deleteAll()
        add(profile)
        return getCurrentProfile()
    }
    
    func updateProfile(_ profile: UserProfileEntity) {
        update(profile)
    }
    
    func updateAndGetProfile(_ profile: UserProfileEntity) -> UserProfileEntity? {
        update(profile)
        return getProfileByID(profile.id)
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let profile = items[index]
            delete(profile)
        }
    }
    
    func delete(by id: String) {
        guard let profile = items.first(where: { $0.id == id }) else {
            FSLogger.error("Profile with id \(id) not found")
            return
        }
        delete(profile)
    }
    
    /// Deletes all messages from the data store.
    func deleteAll() {
        items.forEach { item in
            delete(item)
        }
    }
}
