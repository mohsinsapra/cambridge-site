#!/usr/bin/env swift
//
// generate_app_icons.swift
//
// Draws the CamBridge logomark with CoreGraphics (same geometry/colors as
// brand/logo/logomark.svg — aperture ring "bridging" down to a signal arc
// that lands on two device nodes) onto the brand's dark background, then
// renders the full macOS AppIcon.appiconset size set and the key iOS
// AppIcon sizes as PNGs.
//
// Run:  swift brand/generate_app_icons.swift
// Output: brand/appicons/macos/*.png, brand/appicons/ios/*.png
//

import AppKit
import CoreGraphics

// MARK: - Brand colors (see brand/BRAND.md)

let bgColor    = NSColor(srgbRed: 0x0C/255.0, green: 0x0A/255.0, blue: 0x08/255.0, alpha: 1.0) // --bg
let amber      = NSColor(srgbRed: 0xE3/255.0, green: 0xA8/255.0, blue: 0x55/255.0, alpha: 1.0) // --accent
let teal       = NSColor(srgbRed: 0x6F/255.0, green: 0xA8/255.0, blue: 0xA0/255.0, alpha: 1.0) // --accent-2

// MARK: - Drawing

/// Draws the logomark into a square bitmap of exactly `size` x `size` pixels
/// (device pixels, not points — a plain CGBitmapContext so retina backing
/// scale never doubles the output), using the same 0-100 coordinate space
/// as logomark.svg, scaled up.
func drawLogomark(size: CGFloat) -> CGImage? {
    let pixelSize = Int(size.rounded())
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard let ctx = CGContext(
        data: nil,
        width: pixelSize,
        height: pixelSize,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    ) else { return nil }

    let scale = size / 100.0

    // background — rounded square like an app icon canvas fill (macOS/iOS
    // apply their own mask, so a plain fill is correct here)
    ctx.setFillColor(bgColor.cgColor)
    ctx.fill(CGRect(x: 0, y: 0, width: size, height: size))

    // Flip to a top-left origin, y-down space matching the SVG's coordinates.
    ctx.translateBy(x: 0, y: size)
    ctx.scaleBy(x: 1, y: -1)

    func pt(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        CGPoint(x: x * scale, y: y * scale)
    }

    // Bridge arc: M 21 76 Q 50 52 79 76
    let bridge = CGMutablePath()
    bridge.move(to: pt(21, 76))
    bridge.addQuadCurve(to: pt(79, 76), control: pt(50, 52))

    ctx.saveGState()
    ctx.setStrokeColor(teal.cgColor)
    ctx.setLineWidth(7 * scale)
    ctx.setLineCap(.round)
    ctx.addPath(bridge)
    ctx.strokePath()
    ctx.restoreGState()

    // Device nodes
    ctx.setFillColor(teal.cgColor)
    let nodeR: CGFloat = 6.5 * scale
    ctx.fillEllipse(in: CGRect(x: pt(21, 76).x - nodeR, y: pt(21, 76).y - nodeR, width: nodeR * 2, height: nodeR * 2))
    ctx.fillEllipse(in: CGRect(x: pt(79, 76).x - nodeR, y: pt(79, 76).y - nodeR, width: nodeR * 2, height: nodeR * 2))

    // Lens ring
    ctx.saveGState()
    ctx.setStrokeColor(amber.cgColor)
    ctx.setLineWidth(8 * scale)
    let ringR: CGFloat = 21 * scale
    let center = pt(50, 38)
    ctx.strokeEllipse(in: CGRect(x: center.x - ringR, y: center.y - ringR, width: ringR * 2, height: ringR * 2))
    ctx.restoreGState()

    // Aperture center dot
    ctx.setFillColor(amber.cgColor)
    let dotR: CGFloat = 6.5 * scale
    ctx.fillEllipse(in: CGRect(x: center.x - dotR, y: center.y - dotR, width: dotR * 2, height: dotR * 2))

    return ctx.makeImage()
}

func writePNG(_ cgImage: CGImage?, to path: String, size: CGFloat) {
    guard let cgImage = cgImage else {
        fputs("No image to write for \(path)\n", stderr)
        return
    }
    let rep = NSBitmapImageRep(cgImage: cgImage)
    guard let png = rep.representation(using: .png, properties: [:]) else {
        fputs("Failed to encode PNG for \(path)\n", stderr)
        return
    }
    let url = URL(fileURLWithPath: path)
    do {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try png.write(to: url)
        print("wrote \(path) (\(Int(size))x\(Int(size)))")
    } catch {
        fputs("Failed to write \(path): \(error)\n", stderr)
    }
}

// MARK: - Output paths

let scriptDir = URL(fileURLWithPath: #filePath).deletingLastPathComponent().path
let macDir = scriptDir + "/appicons/macos"
let iosDir = scriptDir + "/appicons/ios"

// macOS AppIcon.appiconset canonical sizes (point size, scale, output px)
struct IconSpec { let label: String; let px: CGFloat }

let macSpecs: [IconSpec] = [
    IconSpec(label: "icon_16x16",       px: 16),
    IconSpec(label: "icon_16x16@2x",    px: 32),
    IconSpec(label: "icon_32x32",       px: 32),
    IconSpec(label: "icon_32x32@2x",    px: 64),
    IconSpec(label: "icon_128x128",     px: 128),
    IconSpec(label: "icon_128x128@2x",  px: 256),
    IconSpec(label: "icon_256x256",     px: 256),
    IconSpec(label: "icon_256x256@2x",  px: 512),
    IconSpec(label: "icon_512x512",     px: 512),
    IconSpec(label: "icon_512x512@2x",  px: 1024),
]

// iOS: App Store icon + common home-screen / settings / spotlight sizes.
let iosSpecs: [IconSpec] = [
    IconSpec(label: "icon_1024x1024",     px: 1024), // App Store
    IconSpec(label: "icon_20x20@2x",      px: 40),
    IconSpec(label: "icon_20x20@3x",      px: 60),
    IconSpec(label: "icon_29x29@2x",      px: 58),
    IconSpec(label: "icon_29x29@3x",      px: 87),
    IconSpec(label: "icon_40x40@2x",      px: 80),
    IconSpec(label: "icon_40x40@3x",      px: 120),
    IconSpec(label: "icon_60x60@2x",      px: 120),
    IconSpec(label: "icon_60x60@3x",      px: 180),
    IconSpec(label: "icon_76x76@2x",      px: 152),
    IconSpec(label: "icon_83.5x83.5@2x",  px: 167),
]

for spec in macSpecs {
    let img = drawLogomark(size: spec.px)
    writePNG(img, to: "\(macDir)/\(spec.label).png", size: spec.px)
}

for spec in iosSpecs {
    let img = drawLogomark(size: spec.px)
    writePNG(img, to: "\(iosDir)/\(spec.label).png", size: spec.px)
}

print("Done. macOS icons in \(macDir), iOS icons in \(iosDir).")
