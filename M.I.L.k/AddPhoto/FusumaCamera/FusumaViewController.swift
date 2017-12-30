//
//  FusumaViewController.swift
//  Fusuma
//
//  Created by Yuta Akizuki on 2015/11/14.
//  Copyright © 2015年 ytakzk. All rights reserved.
//

import UIKit
import Photos

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

public protocol FusumaDelegate: class {
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode)
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode)
    func fusumaVideoCompleted(withFileURL fileURL: URL)
    func fusumaCameraRollUnauthorized()
}

public extension FusumaDelegate {
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {}
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {}
    func fusumaClosed() {}
    func fusumaWillClosed() {}
}

public var fusumaBaseTintColor   = UIColor.hex("#FFFFFF", alpha: 1.0)
public var fusumaTintColor       = UIColor.hex("#F38181", alpha: 1.0)
public var fusumaBackgroundColor = UIColor.hex("#3B3D45", alpha: 1.0)

public var fusumaAlbumImage: UIImage?
public var fusumaCameraImage: UIImage?
public var fusumaVideoImage: UIImage?
public var fusumaCheckImage: UIImage?
public var fusumaCloseImage: UIImage?
public var fusumaFlashOnImage: UIImage?
public var fusumaFlashOffImage: UIImage?
public var fusumaFlipImage: UIImage?
public var fusumaShotImage: UIImage?

public var fusumaVideoStartImage: UIImage?
public var fusumaVideoStopImage: UIImage?

public var fusumaCropImage: Bool  = true

public var fusumaSavesImage: Bool = false

public var fusumaCameraRollTitle = "CAMERA ROLL"
public var fusumaCameraTitle     = "PHOTO"
public var fusumaVideoTitle      = "VIDEO"
public var fusumaTitleFont       = UIFont(name: "AvenirNext-DemiBold", size: 15)

public var fusumaTintIcons: Bool = true

@objc public enum FusumaMode: Int {
    
    case camera
    case postCamera
    case library
    case video
    case none
}

public struct ImageMetadata {
    public let mediaType: PHAssetMediaType
    public let pixelWidth: Int
    public let pixelHeight: Int
    public let creationDate: Date?
    public let modificationDate: Date?
    public let location: CLLocation?
    public let duration: TimeInterval
    public let isFavourite: Bool
    public let isHidden: Bool
}

public class FusumaViewController: UIViewController {

    @objc public var hasVideo = false
    @objc public var cropHeightRatio: CGFloat = 1
    @objc public var allowMultipleSelection: Bool = false

    fileprivate var mode: FusumaMode = .none
    @objc public var defaultMode: FusumaMode = .library
    fileprivate var willFilter = true

    @IBOutlet weak var photoLibraryViewerContainer: UIView!
    @IBOutlet weak var cameraShotContainer: UIView!
    @IBOutlet weak var videoShotContainer: UIView!

    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
 

    @IBOutlet var libraryFirstConstraints: [NSLayoutConstraint]!
    @IBOutlet var cameraFirstConstraints: [NSLayoutConstraint]!
    
    @objc lazy var albumView  = FSAlbumView.instance()
    @objc lazy var cameraView = FSCameraView.instance()
    @objc lazy var videoView  = FSVideoCameraView.instance()
    
    var sharePhotoController = SharePhotoController()
    
    var firstTimeLoading : Bool = true
    
    lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleClose))
        button.width = 44
        return button
    }()
    
    @objc func handleClose(){
        self.dismiss(animated: true) {
            self.delegate?.fusumaClosed()
        }
    }
    
    lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "NEXT", style: .plain, target: self, action: #selector(handleDone))
        button.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15) ], for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    @objc func handleDone(){
        allowMultipleSelection ? fusumaDidFinishInMultipleMode() : fusumaDidFinishInSingleMode()
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    lazy var redoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "back_arrow").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleRedo))
        button.tintColor = UIColor.white
        return button
    }()
    
    @objc func handleRedo(){
        changeMode(.camera)
        cameraView.initialize()
    }
    
    fileprivate var hasGalleryPermission: Bool {
        
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    public weak var delegate: FusumaDelegate? = nil
    
    override public func loadView() {
        
        if let view = UINib(nibName: "FusumaViewController", bundle: Bundle(for: self.classForCoder)).instantiate(withOwner: self, options: nil).first as? UIView {
            
            self.view = view
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = fusumaBackgroundColor
        
        cameraView.delegate = self
        albumView.delegate  = self
        videoView.delegate  = self

        navigationController?.navigationBar.barTintColor = fusumaBackgroundColor
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: fusumaTitleFont ?? UIFont.systemFont(ofSize: 15)]
        
        albumView.allowMultipleSelection = allowMultipleSelection
        
        let bundle = Bundle(for: self.classForCoder)
        
        // Get the custom button images if they're set
        let albumImage = fusumaAlbumImage != nil ? fusumaAlbumImage : UIImage(named: "ic_insert_photo", in: bundle, compatibleWith: nil)
        let cameraImage = fusumaCameraImage != nil ? fusumaCameraImage : UIImage(named: "ic_photo_camera", in: bundle, compatibleWith: nil)
        
        if fusumaTintIcons {
            
            let albumImage  = albumImage?.withRenderingMode(.alwaysTemplate)
            let cameraImage = cameraImage?.withRenderingMode(.alwaysTemplate)

            libraryButton.setImage(albumImage, for: UIControlState())
            libraryButton.setImage(albumImage, for: .highlighted)
            libraryButton.setImage(albumImage, for: .selected)
            libraryButton.tintColor = fusumaTintColor
            libraryButton.adjustsImageWhenHighlighted = false

            cameraButton.setImage(cameraImage, for: UIControlState())
            cameraButton.setImage(cameraImage, for: .highlighted)
            cameraButton.setImage(cameraImage, for: .selected)
            cameraButton.tintColor = fusumaTintColor
            cameraButton.adjustsImageWhenHighlighted = false
            
            navigationItem.leftBarButtonItem = closeButton
            navigationItem.rightBarButtonItem = doneButton
            
        } else {
            
            libraryButton.setImage(albumImage, for: UIControlState())
            libraryButton.setImage(albumImage, for: .highlighted)
            libraryButton.setImage(albumImage, for: .selected)
            libraryButton.tintColor = nil
            
            cameraButton.setImage(cameraImage, for: UIControlState())
            cameraButton.setImage(cameraImage, for: .highlighted)
            cameraButton.setImage(cameraImage, for: .selected)
            cameraButton.tintColor = nil
            
            navigationItem.leftBarButtonItem = closeButton
            navigationItem.rightBarButtonItem = doneButton
        }
        
        cameraButton.clipsToBounds  = true
        libraryButton.clipsToBounds = true
        videoButton.clipsToBounds   = true
        
        photoLibraryViewerContainer.addSubview(albumView)
        cameraShotContainer.addSubview(cameraView)
        videoShotContainer.addSubview(videoView)
        
        //titleLabel.textColor = fusumaBaseTintColor
        //titleLabel.font      = fusumaTitleFont
        
        if !hasVideo {
            
            videoButton.removeFromSuperview()
            
            self.view.addConstraint(NSLayoutConstraint(
                item:       self.view,
                attribute:  .trailing,
                relatedBy:  .equal,
                toItem:     cameraButton,
                attribute:  .trailing,
                multiplier: 1.0,
                constant:   0
            ))
        }
        
        if fusumaCropImage {
            
            let heightRatio = getCropHeightRatio()
            
            cameraView.croppedAspectRatioConstraint = NSLayoutConstraint(
                item: cameraView.previewViewContainer,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: cameraView.previewViewContainer,
                attribute: NSLayoutAttribute.width,
                multiplier: heightRatio,
                constant: 0)

            cameraView.fullAspectRatioConstraint.isActive     = false
            cameraView.croppedAspectRatioConstraint?.isActive = true
            
        } else {
            
            cameraView.fullAspectRatioConstraint.isActive     = true
            cameraView.croppedAspectRatioConstraint?.isActive = false
        }
        
        firstTimeLoading = true
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        albumView.frame  = CGRect(origin: CGPoint.zero, size: photoLibraryViewerContainer.frame.size)
        albumView.layoutIfNeeded()
        cameraView.frame = CGRect(origin: CGPoint.zero, size: cameraShotContainer.frame.size)
        cameraView.layoutIfNeeded()

        if firstTimeLoading == true {
            
            albumView.initialize()
            cameraView.initialize()
            
            if hasVideo {

                videoView.frame = CGRect(origin: CGPoint.zero, size: videoShotContainer.frame.size)
                videoView.layoutIfNeeded()
                videoView.initialize()
            }
        
        
            changeMode(defaultMode)
            firstTimeLoading = false
        }
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.stopAll()
    }

    override public var prefersStatusBarHidden : Bool {
        
        return true
    }
    
    @IBAction func libraryButtonPressed(_ sender: UIButton) {
        
        changeMode(FusumaMode.library)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
    
        changeMode(FusumaMode.camera)
    }
    
    @IBAction func videoButtonPressed(_ sender: UIButton) {
        
        changeMode(FusumaMode.video)
    }
    
    private func fusumaDidFinishInSingleMode() {
        
        guard let view = albumView.imageCropView else { return }
        
        if fusumaCropImage {
            
            let normalizedX = view.contentOffset.x / view.contentSize.width
            let normalizedY = view.contentOffset.y / view.contentSize.height
            
            let normalizedWidth  = view.frame.width / view.contentSize.width
            let normalizedHeight = view.frame.height / view.contentSize.height
            
            let cropRect = CGRect(x: normalizedX, y: normalizedY,
                                  width: normalizedWidth, height: normalizedHeight)
            
            requestImage(with: self.albumView.phAsset, cropRect: cropRect) { (asset, image) in
                
                self.delegate?.fusumaImageSelected(image, source: self.mode)
                
                //SET SHARE PHOTO IMAGE
                self.sharePhotoController.selectedImage = image
                
                let metaData = ImageMetadata(
                    mediaType: self.albumView.phAsset.mediaType,
                    pixelWidth: self.albumView.phAsset.pixelWidth,
                    pixelHeight: self.albumView.phAsset.pixelHeight,
                    creationDate: self.albumView.phAsset.creationDate,
                    modificationDate: self.albumView.phAsset.modificationDate,
                    location: self.albumView.phAsset.location,
                    duration: self.albumView.phAsset.duration,
                    isFavourite: self.albumView.phAsset.isFavorite,
                    isHidden: self.albumView.phAsset.isHidden)
                
                self.delegate?.fusumaImageSelected(image, source: self.mode, metaData: metaData)
            }
            
        } else {
            
            print("no image crop ")
            delegate?.fusumaImageSelected(view.image, source: mode)
            
            //SET SHARE PHOTO IMAGE
            sharePhotoController.selectedImage = view.image
        }
    }
    
    private func requestImage(with asset: PHAsset, cropRect: CGRect, completion: @escaping (PHAsset, UIImage) -> Void) {
        
        DispatchQueue.global(qos: .default).async(execute: {
            
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            options.normalizedCropRect = cropRect
            options.resizeMode = .exact
            
            let targetWidth  = floor(CGFloat(asset.pixelWidth) * cropRect.width)
            let targetHeight = floor(CGFloat(asset.pixelHeight) * cropRect.height)
            let dimensionW   = max(min(targetHeight, targetWidth), 1024 * UIScreen.main.scale)
            let dimensionH   = dimensionW * self.getCropHeightRatio()
            
            let targetSize   = CGSize(width: dimensionW, height: dimensionH)
            
            PHImageManager.default().requestImage(
                for: asset, targetSize: targetSize,
                contentMode: .aspectFill, options: options) { result, info in

                guard let result = result else { return }
                    
                DispatchQueue.main.async(execute: {
                    
                    completion(asset, result)
                })
            }
        })
    }
    
    private func fusumaDidFinishInMultipleMode() {
        
        guard let view = albumView.imageCropView else { return }
        
        let normalizedX = view.contentOffset.x / view.contentSize.width
        let normalizedY = view.contentOffset.y / view.contentSize.height
        
        let normalizedWidth  = view.frame.width / view.contentSize.width
        let normalizedHeight = view.frame.height / view.contentSize.height
        
        let cropRect = CGRect(x: normalizedX, y: normalizedY,
                              width: normalizedWidth, height: normalizedHeight)
        
        var images = [UIImage]()
        
        for asset in albumView.selectedAssets {
            
            requestImage(with: asset, cropRect: cropRect) { asset, result in
                
                images.append(result)
                
                if asset == self.albumView.selectedAssets.last {
                    
                    self.dismiss(animated: true) {
                     
                        if let _ = self.delegate?.fusumaMultipleImageSelected {
                        
                            self.delegate?.fusumaMultipleImageSelected(images, source: self.mode)
                        }
                    }
                }
            }
        }
    }
}

extension FusumaViewController: FSAlbumViewDelegate, FSCameraViewDelegate, FSVideoCameraViewDelegate {
    
    public func getCropHeightRatio() -> CGFloat {
        
        return cropHeightRatio
    }
    
    // MARK: FSCameraViewDelegate
    func cameraShotFinished(_ image: UIImage) {
        
        changeMode(.postCamera)

    }
    
    public func albumViewCameraRollAuthorized() {
        
        // in the case that we're just coming back from granting photo gallery permissions
        // ensure the done button is visible if it should be
        self.updateDoneButtonVisibility()
    }
    
    // MARK: FSAlbumViewDelegate
    public func albumViewCameraRollUnauthorized() {
        
        delegate?.fusumaCameraRollUnauthorized()
    }
    
    func videoFinished(withFileURL fileURL: URL) {
        
        delegate?.fusumaVideoCompleted(withFileURL: fileURL)
        self.dismiss(animated: true, completion: nil)
    }
    
}

private extension FusumaViewController {
    
    func stopAll() {
        
        if hasVideo {

            self.videoView.stopCamera()
        }
        
        self.cameraView.stopCamera()
    }
    
    func changeMode(_ mode: FusumaMode) {

        if self.mode == mode { return }

        //operate this switch before changing mode to stop cameras
        switch self.mode {
        
        case .camera:
            
            self.cameraView.stopCamera()
        
        case .video:
        
            self.videoView.stopCamera()
        
        default:
        
            break
        }
        
        self.mode = mode
        
        dishighlightButtons()
        updateDoneButtonVisibility()
        
        switch mode {
            
        case .library:
            
            navigationItem.title = NSLocalizedString(fusumaCameraRollTitle, comment: fusumaCameraRollTitle)
            highlightButton(libraryButton)
            self.view.bringSubview(toFront: photoLibraryViewerContainer)
        
        case .camera:
            
            navigationItem.title = NSLocalizedString(fusumaCameraTitle, comment: fusumaCameraTitle)
            navigationItem.leftBarButtonItem = closeButton
            highlightButton(cameraButton)
            self.view.bringSubview(toFront: cameraShotContainer)
            cameraView.startCamera()
            
        case .postCamera:
            navigationItem.leftBarButtonItem = redoButton
            navigationItem.rightBarButtonItem = doneButton
            highlightButton(cameraButton)
            
        case .video:
            
            navigationItem.title = fusumaVideoTitle
            highlightButton(videoButton)
            self.view.bringSubview(toFront: videoShotContainer)
            videoView.startCamera()
            
        default:
            
            break
        }
        
        //doneButton.isHidden = !hasGalleryPermission
    }
    
    func updateDoneButtonVisibility() {

        // don't show the done button without gallery permission
        if !hasGalleryPermission {
            
            self.navigationItem.rightBarButtonItem = nil
            return
        }

        
        switch self.mode {
            
        case .camera:
            self.navigationItem.rightBarButtonItem = nil
            
        case .library:
            
            self.navigationItem.rightBarButtonItem = doneButton
            
        case .postCamera:
            
            self.navigationItem.rightBarButtonItem = doneButton
            
        default:
            self.navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    func dishighlightButtons() {
        
        cameraButton.tintColor  = fusumaBaseTintColor
        libraryButton.tintColor = fusumaBaseTintColor

        if cameraButton.layer.sublayers?.count > 1,
            let sublayers = cameraButton.layer.sublayers {
            
            for layer in sublayers {
                
                if let borderColor = layer.borderColor,
                    UIColor(cgColor: borderColor) == fusumaTintColor {
                    
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        if libraryButton.layer.sublayers?.count > 1,
            let sublayers = libraryButton.layer.sublayers {
            
            for layer in sublayers {
                
                if let borderColor = layer.borderColor,
                    UIColor(cgColor: borderColor) == fusumaTintColor {
                    
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        if let videoButton = videoButton,
            videoButton.layer.sublayers?.count > 1,
            let sublayers = videoButton.layer.sublayers {
            
            videoButton.tintColor = fusumaBaseTintColor
            
            for layer in sublayers {
                
                if let borderColor = layer.borderColor,
                    UIColor(cgColor: borderColor) == fusumaTintColor {
                    
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    func highlightButton(_ button: UIButton) {
        
        button.tintColor = fusumaTintColor
        button.addBottomBorder(fusumaTintColor, width: 3)
    }
}
