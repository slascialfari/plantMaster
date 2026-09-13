import SwiftUI
import PhotosUI

struct AddPhotoMenu: View {
    var onImagePicked: (UIImage) -> Void

    @State private var showCamera = false
    @State private var photosPickerItems: [PhotosPickerItem] = []

    var body: some View {
        Menu {
            Button {
                showCamera = true
            } label: {
                Label("Take Photo", systemImage: "camera")
            }
            .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))

            PhotosPicker(selection: $photosPickerItems, matching: .images) {
                Label("Choose from Library", systemImage: "photo.on.rectangle")
            }
        } label: {
            Label("Add Photo", systemImage: "plus.circle.fill")
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraCaptureView { image in
                onImagePicked(image)
            }
            .ignoresSafeArea()
        }
        .onChange(of: photosPickerItems) { _, newItems in
            guard !newItems.isEmpty else { return }
            Task {
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        onImagePicked(image)
                    }
                }
                photosPickerItems = []
            }
        }
    }
}
