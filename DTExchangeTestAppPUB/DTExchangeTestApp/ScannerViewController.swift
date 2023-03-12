//
//  ScannerViewController.swift
//  DTExchangeTestApp
//
//  Created by Digital Turbine on 26/09/2021.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

import UIKit
import AVFoundation

typealias JSON = [String: Any]

enum QRRequestDataKey: String {
    case portal
    case mock
}

enum GetDataFailureReason: Error {
    case parsingError(
        title: String? = "Failed to parse QR Data",
        description: String?
    )
    
    case notSupported(
        title: String? = "Scanning not supported",
        description: String? = "Your device does not support scanning a code from an item. Please use a device with a camera."
    )
}

protocol ScannerViewControllerDelegate: AnyObject {
    func successfullyFetchedData(json: JSON)
    func failedToFetchData(error: GetDataFailureReason)
}

class ScannerViewController: UIViewController {
    private weak var delegate: ScannerViewControllerDelegate?
    
    private lazy var captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        return captureSession
    }()
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.frame = view.layer.bounds
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    
    // MARK: - Setup
    
    func setup(delegate: ScannerViewControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard setupCaptureSession() else { return }
        
        setupSubViews()
        captureSession.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession.isRunning == false {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
    }
}

// MARK: - Orientation
extension ScannerViewController {
    private func videoOrientation(for deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        switch deviceOrientation {
        case .portrait:
            return .portrait
        case .landscapeRight:
            return .landscapeLeft
        case .landscapeLeft:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayerConnection = self.previewLayer.connection,
              previewLayerConnection.isVideoOrientationSupported else { return }
            
        previewLayerConnection.videoOrientation = videoOrientation(for: UIDevice.current.orientation)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.previewLayer.frame = self.view.bounds
        }
    }
}

// MARK: - Serivce
private extension ScannerViewController {
    func addVideoInputToCaptureSession(videoInput: AVCaptureInput) -> Bool {
        var res = false
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
            res = true
        }
        
        return res
    }
    
    func setupAVCaptureInput() -> AVCaptureInput? {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
                  return nil
              }
        
        return videoInput
    }
    
    func setupCaptureSession() -> Bool {
        guard let videoInput = setupAVCaptureInput(),
              addVideoInputToCaptureSession(videoInput: videoInput),
              setMetaDetaOutput() else {
                  delegate?.failedToFetchData(error: .notSupported())
                  return false
              }
        return true
    }
    
    func setMetaDetaOutput() -> Bool {
        let metadataOutput = AVCaptureMetadataOutput()
    
        guard captureSession.canAddOutput(metadataOutput) else { return false }
        
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        return true
    }
    
    func setupSubViews() {
        view.backgroundColor = UIColor.black
        view.layer.addSublayer(previewLayer)
    }
    
    func failed(with title: String, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func getDataFromMetaData(metadataObjects: [AVMetadataObject]) -> Data? {
        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let data = readableObject.stringValue?.data(using: .utf8) else {
                  return nil
              }
        return data
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        guard let data = getDataFromMetaData(metadataObjects: metadataObjects) else { return }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.successfullyFetchedData(json: json!)
        } catch let error as NSError {
            delegate?.failedToFetchData(error: .parsingError(description: error.localizedDescription))
        }
        navigationController?.popViewController(animated: true)
    }
}
