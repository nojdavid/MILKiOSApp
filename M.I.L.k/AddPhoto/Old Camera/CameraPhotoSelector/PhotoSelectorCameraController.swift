//
//  CameraController.swift
//  M.I.L.k
//
//  Created by noah davidson on 12/18/17.
//  Copyright © 2017 noah davidson. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoSelectorCameraController : UIViewController, AVCapturePhotoCaptureDelegate{
    
    var ImageOutput: AVCapturePhotoOutput?
    var Device: AVCaptureDevice?
    var VideoInput: AVCaptureDeviceInput?
    var CaptureSession: AVCaptureSession?
    var PreviewLayer: AVCaptureVideoPreviewLayer?
    
    let previewContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    //VIEW FOR PHOTO ACTION OPTIONS
    var flashCameraButton: UIButton?
    lazy var actionContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.lightGray
        
        let capturePhotoButton: UIButton = {
            let button = UIButton(type: UIButtonType.system)
            button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
            return button
        }()
        
        flashCameraButton = {
            let button = UIButton(type: UIButtonType.system)
            button.setImage(#imageLiteral(resourceName: "flash_off").withRenderingMode(.alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(handleToggleFlash), for: .touchUpInside)
            return button
        }()
        
        let flipCameraButton: UIButton = {
            let button = UIButton(type: UIButtonType.system)
            button.setImage(#imageLiteral(resourceName: "flip_camera").withRenderingMode(.alwaysOriginal), for: .normal)
            button.addTarget(self, action: #selector(handleFlipCamera), for: .touchUpInside)
            return button
        }()
        
        containerView.addSubview(capturePhotoButton)
        
        containerView.addSubview(flashCameraButton!)
        containerView.addSubview(flipCameraButton)
        
        
         flipCameraButton.anchor(top: nil, left: nil, bottom: nil, right: capturePhotoButton.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: view.frame.width/5 , width: 44, height: 44)
         flipCameraButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true;
        
        capturePhotoButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true;
        capturePhotoButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true;
        
        
        flashCameraButton?.anchor(top: nil, left: capturePhotoButton.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: view.frame.width/5, paddingBottom: 0, paddingRight: 0, width: 44, height: 44)
        flashCameraButton?.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true;
        
        return containerView
    }()
    
    lazy var cancelBarButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        return button
    }()
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    
    lazy var retakeBarButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "back_arrow").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleRetakePhoto))
        return button
    }()
    
    @objc func handleRetakePhoto(){
        restartCamera()
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = nil
    }
    
    lazy var nextBarButton : UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        return button
    }()
    
    @objc func handleNext(){
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = outputContainerView?.previewIamgeView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    
    //CREATE ENTIRE VIEW LAYOUT
    fileprivate func setupHUD(){
        previewContainerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        view.addSubview(previewContainerView)
        previewContainerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.width)
        
        view.addSubview(actionContainerView)
        actionContainerView.anchor(top: previewContainerView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        
        navigationItem.title = "Camera"
        navigationItem.leftBarButtonItem = cancelBarButton

        setupHUD()
        setupCamera()
    }
    
    @objc func handleToggleFlash(){
        print("Toggling Flash")
        if AVCaptureDevice.authorizationStatus(for: .video) != AVAuthorizationStatus.authorized{
            return
        }

        
        do {
            try Device?.lockForConfiguration()
            if Device?.hasFlash == true {
                let settings = AVCapturePhotoSettings()
                let mode = settings.flashMode
                if mode == AVCaptureDevice.FlashMode.on {
                    print("now off")
                    settings.flashMode = AVCaptureDevice.FlashMode.off
                    flashCameraButton?.setImage(#imageLiteral(resourceName: "flash_off"), for: .normal)
                }else {
                    print("now on")
                    settings.flashMode = AVCaptureDevice.FlashMode.on
                    flashCameraButton?.setImage(#imageLiteral(resourceName: "flash_on"), for: .normal)
                }
                Device?.unlockForConfiguration()
            }
        } catch let err {
            print(err)
        }
        
    }
    
    @objc func handleFlipCamera(){
        if AVCaptureDevice.authorizationStatus(for: .video) != AVAuthorizationStatus.authorized{
            return
        }
        
        CaptureSession?.stopRunning()
        
        CaptureSession?.beginConfiguration()
        
        if CaptureSession != nil {
            for input in (CaptureSession?.inputs)! {
                CaptureSession?.removeInput(input)
            }
            
            let position = VideoInput?.device.position == AVCaptureDevice.Position.front ? AVCaptureDevice.Position.back : AVCaptureDevice.Position.front
            
            
            let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video,position: AVCaptureDevice.Position.unspecified)
            
            for device in deviceDescoverySession.devices {
                if device.position == position {
                    do{
                        VideoInput = try AVCaptureDeviceInput(device: device)
                        if CaptureSession!.canAddInput(VideoInput!){
                            CaptureSession?.addInput(VideoInput!)
                        }
                    } catch let err {
                        print("could not set up camera input", err)
                    }
                }
            }
        }
        CaptureSession?.commitConfiguration()
        
        CaptureSession?.startRunning()
    }
    
    @objc func handleCapturePhoto(){
        
        navigationItem.rightBarButtonItem = nextBarButton
        navigationItem.leftBarButtonItem = retakeBarButton
        
        actionContainerView.isHidden = true
        
        let settings = AVCapturePhotoSettings()
        
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else {return}
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        ImageOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    func stopRecording(){
        CaptureSession?.stopRunning()
        for input in CaptureSession!.inputs{
            CaptureSession?.removeInput(input)
        }
        for output in CaptureSession!.outputs{
            CaptureSession?.removeOutput(output)
        }
    }
    
    var outputContainerView :PhotoSelectorPreviewPhotoContainerView?
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        let previewImage = UIImage(data: imageData)
        
        outputContainerView = PhotoSelectorPreviewPhotoContainerView()
        outputContainerView?.previewIamgeView.image = previewImage
        previewContainerView.addSubview(outputContainerView!)
        outputContainerView?.anchor(top: previewContainerView.topAnchor, left: previewContainerView.leftAnchor, bottom: previewContainerView.bottomAnchor, right: previewContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func restartCamera(){
        if CaptureSession != nil {
            if outputContainerView != nil {
                outputContainerView?.removeFromSuperview()
            }
            
            if PreviewLayer == nil {
                setupPreviewLayer()
            }
            
            actionContainerView.isHidden = false
            
            var cameraAuthorized = AVCaptureDevice.authorizationStatus(for: .video)
            if cameraAuthorized == AVAuthorizationStatus.authorized {
                CaptureSession?.startRunning()
            } else if cameraAuthorized == AVAuthorizationStatus.denied || cameraAuthorized == AVAuthorizationStatus.restricted {
                CaptureSession?.stopRunning()
            }
        }else{
            if outputContainerView != nil {
                outputContainerView?.removeFromSuperview()
            }
            setupCamera()
        }
    }

    fileprivate func setupCamera(){
        if CaptureSession === nil {
            CaptureSession = AVCaptureSession()
            
            Device = getDevice(position: .back)
            
            if Device == nil {
                print("No camera available")
                return
            }
            
            do{
                VideoInput = try AVCaptureDeviceInput(device: Device!)
                if CaptureSession!.canAddInput(VideoInput!){
                    CaptureSession?.addInput(VideoInput!)
                }
            } catch let err {
                print("could not set up camera input", err)
            }
            
            ImageOutput = AVCapturePhotoOutput()
            if CaptureSession!.canAddOutput(ImageOutput!){
                CaptureSession?.addOutput(ImageOutput!)
            }
            
            setupPreviewLayer()
        }
        
        actionContainerView.isHidden = false
        
        var cameraAuthorized = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraAuthorized == AVAuthorizationStatus.authorized {
            CaptureSession?.startRunning()
        } else if cameraAuthorized == AVAuthorizationStatus.denied || cameraAuthorized == AVAuthorizationStatus.restricted {
            CaptureSession?.stopRunning()
        }
    }
    
    fileprivate func setupPreviewLayer(){
        PreviewLayer = AVCaptureVideoPreviewLayer(session: CaptureSession!)
        PreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        PreviewLayer?.frame = previewContainerView.bounds
        previewContainerView.layer.addSublayer(PreviewLayer!)
    }

    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice?{
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position)
    }
}

