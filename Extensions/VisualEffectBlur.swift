import SwiftUI

/// Reusable blur view that mimics the macOS/tvOS "visual effect" (liquid glass).
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style = .systemMaterialDark
    var intensity: CGFloat = 0.5 // 0‑1 – controls how strong the blur looks

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        view.alpha = intensity
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
        uiView.alpha = intensity
    }
}
