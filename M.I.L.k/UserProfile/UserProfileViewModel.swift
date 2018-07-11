//
//  UserProfileViewModel.swift
//  M.I.L.k
//
//  Created by noah davidson on 1/19/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import UIKit

enum UserProfileViewModelItemType {
    case profileHeader
    case section1
    case section2
    case section3
    case section4
}

private func getFacts() -> [FactViewModelItem]{
    var items = [FactViewModelItem]()
    let facts = FactsModel()
    
    let factsSection1 = FactViewModelSection1(facts: facts.section1)
    items.append(factsSection1)
    
    let factsSection2 = FactViewModelSection2(facts: facts.section2)
    items.append(factsSection2)
    
    let factsSection3 = FactViewModelSection3(facts: facts.section3)
    items.append(factsSection3)
    
    let factsSection4 = FactViewModelSection4(facts: facts.section4)
    items.append(factsSection4)
    
    return items
}

private func getUser(user: User) -> UserProfileViewModelHeader{
    
    let userHeader = ProfileModel(user: user)
    
    //TODO:: GET USER POSTS HERE DEPENDENT ON STATE OF HEADER:: (LIKES OR USERPOSTS)
//    getUserPosts(user: user) { (result) in
//        switch result {
//        case .success(let posts):
//            print("SUCCESS GET LIKED POSTS: ", posts)
//            userHeader.photos = posts
//        case .failure(let error):
//            print("FAILURE POSTS:", error)
//        }
//    }
    
    return UserProfileViewModelHeader(user: user, photos: userHeader.posts)
}

//TODO:: IMPLEMENT REAL FETCH USERPOST
//private func getUserPosts(user: User, completion:((Result<[Post]>) -> [Void])?) {
//    FetchPosts(dict: ["author":"\(Store.shared().user?.id)"]) { (result) in
//        switch result {
//        case .success(let posts):
//            //print("SUCCESS GET USER POSTS: ", posts)
//            completion?(.success(posts))
//        case .failure(let error):
//            //print("FAILURE POSTS:", error)
//            completion?(.failure(error))
//        }
//    }
//}

//TODO:: IMPLEMENT REAL FETCH USER LIKES
//private func getUserLikes(user: User, completion:((Result<[Post]>) -> [Void])?) {
//    FetchPosts(dict: ["likes":"\(true)"]) { (result) in
//        switch result {
//        case .success(let posts):
//            print("SUCCESS GET LIKED POSTS: ", posts)
//            completion?(.success(posts))
//        case .failure(let error):
//            print("FAILURE POSTS:", error)
//            completion?(.failure(error))
//        }
//    }
//}

//MARK :- USER PROFILE VIEWMODEL
protocol UserProfileViewModelDelegate {
    func selectPost(viewController: UIViewController)
    func handleGoToSettings(settingsViewController: SettingsController)
}

class UserProfileViewModel: NSObject {
    
    var delegate: UserProfileViewModelDelegate?
    
    var items = [UserProfileViewModelItem]()
    
    var reloadSections: ((_ section: Int,_ numberOfItems: Int,_ collapsed: Bool) -> Void)?
    var reloadAllSections: (() -> Void)?
    var user: User
    //var profileDelegate: UserProfileController?
    var userHeader: UserProfileViewModelHeader
    
    public enum ProfileMode: Int {
        case postView
        case likeView
        case factView
    }
    
    fileprivate var mode: ProfileMode = .postView

    init(user: User) {
        self.user = user
        
        userHeader = getUser(user: user)
        
        items.append(userHeader)
    }
}

//MARK:- USER PROFILE HEADER
extension UserProfileViewModel : UserProfileHeaderDelegate {
    func didChangeToGridView() {
        if mode == .postView{
            return
        }
        
        mode = .postView
        if items.count > 1 {
            for _ in 1 ... items.count-1{
                items.remove(at: 1)
            }
        }
        
        guard let user_id = Store.shared().user?.id else {return}
        
        FetchPosts(dict: ["author":"\(user_id)"]) { (result) in
            switch result {
            case .success(let posts):
                print("SUCCESS GET USER POSTS: ", posts.count)
                self.userHeader.photos = posts
            case .failure(let error):
                print("FAILURE POSTS:", error)
            }
        }
        
//        getUserPosts(user: user) { (result) in
//            switch result {
//            case .success(let posts):
//                print("SUCCESS GET LIKED POSTS: ", posts)
//
//            case .failure(let error):
//                print("FAILURE POSTS:", error)
//            }
//        }
        
        reloadAllSections?()
        
        return
    }
    
    func didChangeToLikeListView() {
        if mode == .likeView {
            return
        }
        
        mode = .likeView
        if items.count > 1 {
            for _ in 1 ... items.count-1{
                items.remove(at: 1)
            }
        }
        
        //FETCH LIKED POSTS
        FetchPosts(dict: ["likes":"\(true)"]) { (result) in
            switch result {
            case .success(let posts):
                print("SUCCESS GET LIKED POSTS: ", posts.count)
                self.userHeader.photos = posts
            case .failure(let error):
                print("FAILURE POSTS:", error)
                
            }
        }
        
        //getUserLikes(user: user)
        
        reloadAllSections?()
    }
    
    func didChangeToFactsView() {
        if mode == .factView {
            return
        }
        
        mode = .factView
        userHeader.photos = []
        
        let facts = FactsModel()
        
        let factsSection1 = FactViewModelSection1(facts: facts.section1)
        items.append(factsSection1)
        
        let factsSection2 = FactViewModelSection2(facts: facts.section2)
        items.append(factsSection2)
        
        let factsSection3 = FactViewModelSection3(facts: facts.section3)
        items.append(factsSection3)
        
        let factsSection4 = FactViewModelSection4(facts: facts.section4)
        items.append(factsSection4)
        
        reloadAllSections?()
    }
    
    func didChangeToSettingsView() {
        delegate?.handleGoToSettings(settingsViewController: SettingsController())
    }
}

//MARK :- USER PROFILE FACT HEADER
extension UserProfileViewModel : UserProfileFactHeaderDelegate {
    func toggleSection(header: UserProfileFactHeader, section: Int) {
        guard var item = items[section] as? FactViewModelItem else {return}
        if item.type != .profileHeader {
            if item.isCollapsible {
                let collapsed = !item.isCollapsed
                item.isCollapsed = collapsed
                header.setCollapsed(collapsed: collapsed)
                reloadSections?(section, item.rowCount,collapsed)
            }
        }
    }
}

//MARK :- FLOW LAYOUT
extension UserProfileViewModel : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if mode == .postView || mode == .likeView{
            return 1
        }else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if mode == .postView || mode == .likeView{
            return 1
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if mode == .postView || mode == .likeView {
            let width = (collectionView.frame.width - 2) / 3
            return CGSize(width: width, height:width)
        } else {
            let height: CGFloat = 50
            let width = collectionView.frame.width
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let item = items[section]
        if item.type == .profileHeader {
            return CGSize(width: collectionView.frame.width, height: 200)
        }else{
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        
    }
}

//MARK :- DATA SOURCE
extension UserProfileViewModel : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mode != .factView {
            let post = userHeader.photos[indexPath.item]
            let detailHomeController = DetailPostController(collectionViewLayout: UICollectionViewFlowLayout())
            detailHomeController.post = post
            self.delegate?.selectPost(viewController: detailHomeController)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let item = items[section] as? FactViewModelItem{
            if item.type != .profileHeader {
                if item.isCollapsible && item.isCollapsed {
                    return 0
                }
            }
        }
        return items[section].rowCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .profileHeader:
            if let item = item as? UserProfileViewModelHeader, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfilePhotoCell.identifier, for: indexPath) as? UserProfilePhotoCell {
                cell.post = item.photos[indexPath.item]
                return cell
            }
        case .section1:
            if let item = item as? FactViewModelSection1, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileFactCell.identifier, for: indexPath) as? UserProfileFactCell{
                cell.fact = item.facts[indexPath.row]
                return cell
            }
        case .section2:
            if let item = item as? FactViewModelSection2, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileFactCell.identifier, for: indexPath) as? UserProfileFactCell{
                cell.fact = item.facts[indexPath.row]
                return cell
            }
        case .section3:
            if let item = item as? FactViewModelSection3, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileFactCell.identifier, for: indexPath) as? UserProfileFactCell{
                cell.fact = item.facts[indexPath.row]
                return cell
            }
        case .section4:
            if let item = item as? FactViewModelSection4, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileFactCell.identifier, for: indexPath) as? UserProfileFactCell{
                cell.fact = item.facts[indexPath.row]
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let item = items[indexPath.section]
        switch item.type {
        case .section1, .section2, .section3, .section4:
            if let item = item as? FactViewModelItem{
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileFactHeader.identifier, for: indexPath) as! UserProfileFactHeader
                
                header.item = item
                header.section = indexPath.section
                header.delegate = self
                
                return header
            }
        case .profileHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeader.identifier, for: indexPath) as! UserProfileHeader
            
            header.user = self.user
            header.delegate = self//.profileDelegate
            return header
        }
        return UICollectionViewCell()
    }
}


//MARK :- COLLECTIONVIEW DATA SOURCE TYPES
protocol UserProfileViewModelItem {
    var type: UserProfileViewModelItemType {get}
    var rowCount: Int {get}
    var sectionTitle: String {get}
}

class UserProfileViewModelHeader : UserProfileViewModelItem {
    var type: UserProfileViewModelItemType{
        return .profileHeader
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return photos.count
    }
    
    var user: User
    var photos: [Post]
    
    init(user: User, photos: [Post]) {
        self.user = user
        self.photos = photos
    }
}


protocol FactViewModelItem : UserProfileViewModelItem{
    var isCollapsible: Bool {get}
    var isCollapsed: Bool {get set}
}

extension FactViewModelItem {
    var rowCount: Int {
        return 1
    }
    
    var isCollapsible:Bool {
        return true
    }
}

class FactViewModelSection1: FactViewModelItem {
    
    var isCollapsed = true
    
    var type: UserProfileViewModelItemType{
        return .section1
    }
    
    var sectionTitle: String {
        return "Section 1"
    }
    
    var rowCount: Int {
        return facts.count
    }
    
    var facts: [String]
    
    init(facts: [String]) {
        self.facts = facts
    }
}

class FactViewModelSection2: FactViewModelItem {
    
    var isCollapsed = true
    
    var type: UserProfileViewModelItemType{
        return .section2
    }
    
    var sectionTitle: String {
        return "Section 2"
    }
    
    var rowCount: Int {
        return facts.count
    }
    
    var facts: [String]
    
    init(facts: [String]) {
        self.facts = facts
    }
}

class FactViewModelSection3: FactViewModelItem {
    
    var isCollapsed = true
    
    var type: UserProfileViewModelItemType{
        return .section3
    }
    
    var sectionTitle: String {
        return "Section 3"
    }
    
    var rowCount: Int {
        return facts.count
    }
    
    var facts: [String]
    
    init(facts: [String]) {
        self.facts = facts
    }
}

class FactViewModelSection4: FactViewModelItem {
    
    var isCollapsed = true
    
    var type: UserProfileViewModelItemType{
        return .section4
    }
    
    var sectionTitle: String {
        return "Section 4"
    }
    
    var rowCount: Int {
        return facts.count
    }
    
    var facts: [String]
    
    init(facts: [String]) {
        self.facts = facts
    }
}









