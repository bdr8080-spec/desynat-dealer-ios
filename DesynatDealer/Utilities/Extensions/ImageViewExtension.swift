//
//  ImageViewExtension.swift
//  DesynatDealer
//
//  Created by fluper on 06/01/26.
//


import UIKit
import SDWebImage

extension UIImageView: UIScrollViewDelegate {

    func enableFullscreenZoom() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(showFullscreen))
        self.addGestureRecognizer(tap)
    }

    private struct AssociatedKeys {
        static var scrollView = "scrollView"
        static var imageView = "imageView"
        static var overlayView = "overlayView"
        static var dismissButton = "dismissButton"
    }

    private var scrollView: UIScrollView? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.scrollView) as? UIScrollView }
        set { objc_setAssociatedObject(self, &AssociatedKeys.scrollView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var fullscreenImageView: UIImageView? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.imageView) as? UIImageView }
        set { objc_setAssociatedObject(self, &AssociatedKeys.imageView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var overlayView: UIView? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.overlayView) as? UIView }
        set { objc_setAssociatedObject(self, &AssociatedKeys.overlayView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var dismissButton: UIButton? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.dismissButton) as? UIButton }
        set { objc_setAssociatedObject(self, &AssociatedKeys.dismissButton, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc private func showFullscreen() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
              let image = self.image else { return }

        // Overlay
        overlayView = UIView(frame: window.bounds)
        overlayView?.backgroundColor = .black
        overlayView?.alpha = 0
        window.addSubview(overlayView!)

        // ScrollView for zoom
        scrollView = UIScrollView(frame: overlayView!.bounds)
        scrollView?.delegate = self
        scrollView?.backgroundColor = .clear
        scrollView?.minimumZoomScale = 1.0
        scrollView?.maximumZoomScale = 4.0
        overlayView?.addSubview(scrollView!)

        // Fullscreen Image
        fullscreenImageView = UIImageView(image: image)
        fullscreenImageView?.contentMode = .scaleAspectFit
        fullscreenImageView?.frame = scrollView!.bounds
        fullscreenImageView?.isUserInteractionEnabled = true
        scrollView?.addSubview(fullscreenImageView!)

        // Double Tap Gesture
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        fullscreenImageView?.addGestureRecognizer(doubleTap)

        // Dismiss Button
        dismissButton = UIButton(frame: CGRect(x: 20, y: 50, width: 50, height: 50))
        dismissButton?.setTitle("✕", for: .normal)
        dismissButton?.titleLabel?.font = .systemFont(ofSize: 30)
        dismissButton?.addTarget(self, action: #selector(dismissFullscreen), for: .touchUpInside)
        overlayView?.addSubview(dismissButton!)

        // Animate in
        UIView.animate(withDuration: 0.3) {
            self.overlayView?.alpha = 1
        }
    }

    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        guard let scrollView = scrollView else { return }

        if scrollView.zoomScale == 1 {
            let point = sender.location(in: fullscreenImageView)
            let width = scrollView.frame.width / 2
            let height = scrollView.frame.height / 2
            let zoomRect = CGRect(x: point.x - width/2, y: point.y - height/2, width: width, height: height)
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullscreenImageView
    }

    @objc private func dismissFullscreen() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView?.alpha = 0
        }, completion: { _ in
            self.fullscreenImageView?.removeFromSuperview()
            self.scrollView?.removeFromSuperview()
            self.dismissButton?.removeFromSuperview()
            self.overlayView?.removeFromSuperview()

            self.fullscreenImageView = nil
            self.scrollView = nil
            self.dismissButton = nil
            self.overlayView = nil
        })
    }
}
