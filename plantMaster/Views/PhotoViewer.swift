import SwiftUI
import SwiftData

/// Full-screen photo viewer. Shows each photo uncropped on black, swipeable when there are
/// several, pinch to zoom, and closes with the X button or a downward swipe.
struct PhotoViewer: View {
    let photos: [PlantPhoto]
    @Binding var selection: PersistentIdentifier?

    @Environment(\.dismiss) private var dismiss
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black
                .opacity(1 - min(abs(Double(dragOffset)) / 400.0, 0.6))
                .ignoresSafeArea()

            TabView(selection: $selection) {
                ForEach(photos) { photo in
                    Group {
                        if let image = PhotoStore.display(filename: photo.filename) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .pinchToZoom()
                        } else {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(Optional(photo.persistentModelID))
                }
            }
            .tabViewStyle(.page(indexDisplayMode: photos.count > 1 ? .always : .never))
            .offset(y: dragOffset)
            .ignoresSafeArea()
            .simultaneousGesture(dismissDrag)

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.2), in: Circle())
            }
            .padding(.trailing, 16)
            .padding(.top, 8)
            .accessibilityLabel("Close photo")
        }
        .statusBarHidden()
    }

    /// Mostly-vertical downward drag closes the viewer; horizontal drags stay with the pager.
    private var dismissDrag: some Gesture {
        DragGesture(minimumDistance: 20)
            .onChanged { value in
                let t = value.translation
                guard t.height > 0, abs(t.height) > abs(t.width) else { return }
                dragOffset = t.height
            }
            .onEnded { value in
                if dragOffset > 120 || value.predictedEndTranslation.height > 300 {
                    dismiss()
                } else {
                    withAnimation(.spring(duration: 0.3)) { dragOffset = 0 }
                }
            }
    }
}
