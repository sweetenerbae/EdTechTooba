//
//  CameraModel.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 25.08.25.
//
import SwiftUI
import AVFoundation

final class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var previewLayer = AVCaptureVideoPreviewLayer()
    
    private let output = AVCapturePhotoOutput()
    private var device: AVCaptureDevice?

    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { self.setupCamera() }
            }
        default:
            break
        }
    }

    private func setupCamera() {
        session.beginConfiguration()
        device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let device else { return }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
            }
        } catch {
            print("Ошибка камеры: \(error)")
        }
    }

    func switchCamera() {
        guard let currentInput = session.inputs.first as? AVCaptureDeviceInput else { return }
        session.beginConfiguration()
        session.removeInput(currentInput)

        let newPosition: AVCaptureDevice.Position = currentInput.device.position == .back ? .front : .back
        if let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition) {
            do {
                let newInput = try AVCaptureDeviceInput(device: newDevice)
                if session.canAddInput(newInput) {
                    session.addInput(newInput)
                }
            } catch {
                print("Ошибка при переключении камеры: \(error)")
            }
        }
        session.commitConfiguration()
    }

    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation() {
            // Тут сохраняем фото или отправляем в Firebase Storage для OCR
            print("Фото сделано, размер: \(data.count) байт")
        }
    }
}
