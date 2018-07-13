//
//  UserProfileViewModel.swift
//  M.I.L.k
//
//  Created by noah davidson on 1/19/18.
//  Copyright © 2018 noah davidson. All rights reserved.
//

import UIKit

//section header types in profile collection view
enum UserProfileViewModelItemType {
    case profileHeader
    case fact_section
}

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
        case none
    }
    
    fileprivate var mode: ProfileMode = .none

    init(user: User) {
        self.user = user
        
        //create user header
        userHeader = UserProfileViewModelHeader(user: user, photos: [Post]())
        items.append(userHeader)
    }
    
    func generateFacts(facts: [Fact]?) {
        var items = [FactViewModelSection]()
        guard let facts = facts else {return}
        
        var sections = [Int: [String]]()
        var sectionsTitles = [Int: String]()
        
        for fact in facts {
            guard let section_id = fact.section_id else {continue}
            if sections[section_id] == nil {
                sections[section_id] = []
                sectionsTitles[section_id] = ""
            }
            sections[section_id]!.append(fact.desc!)
            
            guard let title = fact.section else {continue}
            sectionsTitles[section_id]! = title
        }
        
        for (key,value) in sections {
            let title = sectionsTitles[key] != nil ? sectionsTitles[key] : "Section \(key)"
            let factsSection = FactViewModelSection(facts: value, sectionTitle: title! )
            items.append(factsSection)
        }
        
        self.userHeader.facts = items
    }
    
    func removeItems () {
        //remove other items in the list
        if items.count > 1 {
            for _ in 1 ... items.count-1{
                items.remove(at: 1)
            }
        }
    }
}

//MARK:- USER PROFILE HEADER
extension UserProfileViewModel : UserProfileHeaderDelegate {
    //clicked posts view
    func didChangeToGridView() {
        if mode == .postView{
            return
        }
        
        removeItems()
        
        mode = .postView
        
        guard let user_id = Store.shared().user?.id else {return}
        
        FetchPosts(dict: ["author":"\(user_id)"]) { (result) in
            switch result {
            case .success(let posts):
                print("SUCCESS GET USER POSTS: ", posts.count)
                self.userHeader.photos = posts
                self.reloadAllSections?()
            case .failure(let error):
                print("FAILURE POSTS:", error)
            }
        }
        
        self.reloadAllSections?()
    }
    
    //clicked liked view
    func didChangeToLikeListView() {
        
        if mode == .likeView {
            return
        }
        
        removeItems()
        
        mode = .likeView

        //FETCH LIKED POSTS
        FetchPosts(dict: ["likes":"\(true)"]) { (result) in
            switch result {
            case .success(let posts):
                print("--SUCCESS GET LIKED POSTS: ", posts.count)
                self.userHeader.photos = posts
                self.reloadAllSections?()
            case .failure(let error):
                print("--FAILURE POSTS:", error)
                
            }
        }
        
        self.reloadAllSections?()
    }
    
    //clicked facts view
    func didChangeToFactsView() {
        if mode == .factView {
            return
        }
        
        mode = .factView
        
        //remove other items from list
        self.userHeader.photos = []
        
        self.getFacts()
        
        self.reloadAllSections?()
    }
    
    func didChangeToSettingsView() {
        delegate?.handleGoToSettings(settingsViewController: SettingsController())
    }
    
    func getFacts() {
        FetchFacts(dict: nil) { (result) in
            switch result {
            case .success(let facts):
                print("SUCCESS GET FACTS: ", facts)
                self.generateFacts(facts: facts)
                
                //get generated facts
                guard let facts = self.userHeader.facts else {return}
                
                //append sections to list
                for fact in facts {
                    self.items.append(fact)
                }
                
                self.reloadAllSections?()
            case .failure(let error):
                print("FAILURE POSTS:", error)
            }
        }
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
        switch mode {
            case .postView,.likeView:
                return 1
            case .factView:
                return 0
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch mode {
        case .postView,.likeView:
            return 1
        case .factView:
            return 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch mode {
        case .postView,.likeView:
            let width = (collectionView.frame.width - 2) / 3
            return CGSize(width: width, height:width)
        case .factView:
            //get cell text and make dynamic cell height based on text length
            guard let myCell = collectionView.cellForItem(at: indexPath) as? UserProfileFactCell else { return CGSize()}
            var padding : CGFloat = 20
            var height: CGFloat = 50
            if let text = myCell.factLabel.text {
                height = estimateFrameForText(text: text).height + padding
            }
            let width = collectionView.frame.width
            return CGSize(width: width, height: height)
        default:
            return CGSize()
        }
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        //we make the height arbitrarily large so we don't undershoot height in calculation
        let height: CGFloat = 100
        
        let size = CGSize(width: 50, height: height)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [kCTFontAttributeName: UIFont.systemFont(ofSize: 15, weight: .regular)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes as [NSAttributedStringKey : Any], context: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let item = items[section]
        switch item.type {
        case .profileHeader :
             return CGSize(width: collectionView.frame.width, height: 200)
        default:
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
}

//MARK :- DATA SOURCE
extension UserProfileViewModel : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //if picture cell
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
        case .fact_section:
            if let item = item as? FactViewModelSection, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileFactCell.identifier, for: indexPath) as? UserProfileFactCell{
                cell.fact = item.facts[indexPath.row]
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let item = items[indexPath.section]
        switch item.type {
        case .fact_section:
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
    var facts: [UserProfileViewModelItem]?
    
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

//TODO make generic fact model array maintained at runtime

class FactViewModelSection: FactViewModelItem {
    
    var isCollapsed = true
    
    var type: UserProfileViewModelItemType{
        return .fact_section
    }
    
    var sectionTitle: String = "Section"
    
    var rowCount: Int {
        return facts.count
    }
    
    var facts: [String]
    
    init(facts: [String], sectionTitle: String) {
        self.facts = facts
        self.sectionTitle = sectionTitle
    }
}
