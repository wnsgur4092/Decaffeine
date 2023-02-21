//
//  BeverageListViewModel.swift
//  Decaffeine
//
//  Created by JunHyuk Lim on 17/2/2023.
//

import Foundation
import RealmSwift
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var list: [SelectedBeverage] = []
    @Published var userProfileImage: UIImage?

    private var notificationToken: NotificationToken?


    init() {
        observeListChanges()
        observeUserProfileImage()
    }

    func observeListChanges() {
        do {
            let realm = try Realm()
            notificationToken = realm.objects(SelectedBeverage.self).observe { [weak self] changes in
                guard let self = self else { return }
                switch changes {
                case .initial(let list):
                    self.list = Array(list)
                case .update(let list, _, _, _):
                    self.list = Array(list)
                case .error(let error):
                    print("Realm observe error: \(error)")
                }
            }
        } catch {
            print("Realm observe error: \(error)")
        }
    }
    
    func observeUserProfileImage() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent("userProfileImage").appendingPathExtension("jpg")
            do {
                let imageData = try Data(contentsOf: fileURL)
                let image = UIImage(data: imageData)
                userProfileImage = image
            } catch {
                print("Error loading image : \(error)")
            }
        }
    }
    
    func totalCaffeineForToday() -> Int {
        let calendar = Calendar.current
        let today = Date()
        let filteredList = list.filter {
            calendar.isDate($0.registerDate, inSameDayAs: today)
        }
        let totalCaffeine = filteredList.reduce(0) { $0 + $1.caffeine }
        return totalCaffeine
    }
    
    func numberOfBeveragesForToday() -> Int {
        let calendar = Calendar.current
        let today = Date()
        let filteredList = list.filter {
            calendar.isDate($0.registerDate, inSameDayAs: today)
        }
        return filteredList.count
    }
    
    
}

