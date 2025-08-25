//
//  OCRCameraView.swift
//  EdTechTooba
//
//  Created by Diana Kuchaeva on 25.08.25.
//
import SwiftUI
import AVFoundation

struct OCRCameraView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var camera = CameraModel()

    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Сфокусируйте экран")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        // Допустим — уведомления
                    } label: {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 20))
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding()

                Spacer()

                // Нижняя панель
                HStack(spacing: 40) {
                    Button {
                        camera.switchCamera()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                    }

                    Button {
                        camera.takePhoto()
                    } label: {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                            .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    }

                    Button {
                        // сетка / опции
                    } label: {
                        Image(systemName: "square.grid.2x2")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            camera.checkPermissions()
        }
    }
}
struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.previewLayer.session = camera.session
        camera.previewLayer.videoGravity = .resizeAspectFill
        camera.previewLayer.frame = view.bounds
        view.layer.addSublayer(camera.previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
