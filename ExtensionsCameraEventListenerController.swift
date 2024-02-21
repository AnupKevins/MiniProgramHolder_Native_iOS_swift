//
//  NativeCameraController.swift
//  CoreDataSample
//
//  Created by Sanket Khairnar on 14/02/24.
//  Copyright © 2024 Anup.Sahu. All rights reserved.
//

import UIKit

extension EventListenerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func openPhotoGallery() {
        // Open photo gallery logic
        // This can involve presenting a UIImagePickerController or navigating to a specific view controller
        // Example:
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self // Make sure your view controller conforms to UIImagePickerControllerDelegate and UINavigationControllerDelegate
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            sendImageToReactJS(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func sendImageToReactJS(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.9)?.base64EncodedString() else {
            return
        }
        let javaScript = "javascript:handleImageData('\(imageData)')"
        webView.evaluateJavaScript(javaScript, completionHandler: nil)
    }
}

