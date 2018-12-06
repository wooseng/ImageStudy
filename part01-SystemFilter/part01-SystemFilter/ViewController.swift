//
//  ViewController.swift
//  part01-系统滤镜
//
//  Created by 詹保成 on 2018/12/4.
//  Copyright © 2018 残无殇. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "系统滤镜"
        setMainTableView()
    }
    
    private let dataSource: [(title: String, list: [String])] = [
        ("CICategoryBlur", ["CIBoxBlur", "CIDiscBlur", "CIGaussianBlur", "CIMaskedVariableBlur",
                            "CIMedianFilter", "CIMotionBlur", "CINoiseReduction", "CIZoomBlur"]),
        ("CICategoryColorAdjustment", ["CIColorClamp", "CIColorControls", "CIColorMatrix", "CIColorPolynomial",
                                       "CIExposureAdjust", "CIGammaAdjust", "CIHueAdjust", "CILinearToSRGBToneCurve",
                                       "CISRGBToneCurveToLinear", "CITemperatureAndTint", "CIToneCurve", "CIVibrance",
                                       "CIWhitePointAdjust"]),
        ("CICategoryColorEffect", ["CIColorCrossPolynomial", "CIColorCube", "CIColorCubeWithColorSpace", "CIColorInvert",
                                   "CIColorMap", "CIColorMonochrome", "CIColorPosterize", "CIFalseColor",
                                   "CIMaskToAlpha", "CIMaximumComponent", "CIMinimumComponent", "CIPhotoEffectChrome",
                                   "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir",
                                   "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CISepiaTone",
                                   "CIVignette", "CIVignetteEffect"]),
        ("CICategoryCompositeOperation", ["CIAdditionCompositing", "CIColorBlendMode", "CIColorBurnBlendMode", "CIColorDodgeBlendMode",
                                          "CIDarkenBlendMode", "CIDifferenceBlendMode", "CIDivideBlendMode", "CIExclusionBlendMode",
                                          "CIHardLightBlendMode", "CIHueBlendMode", "CILightenBlendMode", "CILinearBurnBlendMode",
                                          "CILinearDodgeBlendMode", "CILuminosityBlendMode", "CIMaximumCompositing", "CIMinimumCompositing",
                                          "CIMultiplyBlendMode", "CIMultiplyCompositing", "CIOverlayBlendMode", "CIPinLightBlendMode",
                                          "CISaturationBlendMode", "CIScreenBlendMode", "CISoftLightBlendMode", "CISourceAtopCompositing",
                                          "CISourceInCompositing", "CISourceOutCompositing", "CISourceOverCompositing", "CISubtractBlendMode"]),
        ("CICategoryDistortionEffect", ["CIBumpDistortion", "CIBumpDistortionLinear", "CICircleSplashDistortion", "CICircularWrap",
                                        "CIDroste", "CIDisplacementDistortion", "CIGlassDistortion", "CIGlassLozenge",
                                        "CIHoleDistortion", "CILightTunnel", "CIPinchDistortion", "CIStretchCrop",
                                        "CITorusLensDistortion", "CITwirlDistortion", "CIVortexDistortion"]),
        ("CICategoryGenerator", ["CIAztecCodeGenerator", "CICheckerboardGenerator", "CICode128BarcodeGenerator", "CIConstantColorGenerator",
                                 "CILenticularHaloGenerator", "CIPDF417BarcodeGenerator", "CIQRCodeGenerator", "CIRandomGenerator",
                                 "CIStarShineGenerator", "CIStripesGenerator", "CISunbeamsGenerator"]),
        ("CICategoryGeometryAdjustment", ["CIAffineTransform", "CICrop", "CILanczosScaleTransform", "CIPerspectiveCorrection",
                                          "CIPerspectiveTransform", "CIPerspectiveTransformWithExtent", "CIStraightenFilter"]),
        ("CICategoryGradient", ["CIGaussianGradient", "CILinearGradient", "CIRadialGradient", "CISmoothLinearGradient"]),
        ("CICategoryHalftoneEffect", ["CICircularScreen", "CICMYKHalftone", "CIDotScreen", "CIHatchedScreen", "CILineScreen"]),
        ("CICategoryReduction", ["CIAreaAverage", "CIAreaHistogram", "CIRowAverage", "CIColumnAverage", "CIHistogramDisplayFilter",
                                 "CIAreaMaximum", "CIAreaMinimum", "CIAreaMaximumAlpha", "CIAreaMinimumAlpha"]),
        ("CICategorySharpen", ["CISharpenLuminance", "CIUnsharpMask"]),
        ("CICategoryStylize", ["CIBlendWithAlphaMask", "CIBlendWithMask", "CIBloom", "CIComicEffect", "CIConvolution3X3",
                               "CIConvolution5X5", "CIConvolution7X7", "CIConvolution9Horizontal", "CIConvolution9Vertical",
                               "CICrystallize", "CIDepthOfField", "CIEdges", "CIEdgeWork", "CIGloom", "CIHeightFieldFromMask",
                               "CIHexagonalPixellate", "CIHighlightShadowAdjust", "CILineOverlay", "CIPixellate",
                               "CIPointillize", "CIShadedMaterial", "CISpotColor", "CISpotLight"]),
        ("CICategoryTileEffect", ["CIAffineClamp", "CIAffineTile", "CIEightfoldReflectedTile", "CIFourfoldReflectedTile",
                                  "CIFourfoldRotatedTile", "CIFourfoldTranslatedTile", "CIGlideReflectedTile", "CIKaleidoscope",
                                  "CIOpTile", "CIParallelogramTile", "CIPerspectiveTile", "CISixfoldReflectedTile", "CISixfoldRotatedTile",
                                  "CITriangleKaleidoscope", "CITriangleTile", "CITwelvefoldReflectedTile"]),
        ("CICategoryTransition", ["CIAccordionFoldTransition", "CIBarsSwipeTransition", "CICopyMachineTransition",
                                  "CIDisintegrateWithMaskTransition", "CIDissolveTransition", "CIFlashTransition",
                                  "CIModTransition", "CIPageCurlTransition", "CIPageCurlWithShadowTransition",
                                  "CIRippleTransition", "CISwipeTransition"])
    ]
    
    private let mainTableView = UITableView.init(frame: .zero, style: .plain)
    
    private func setMainTableView() {
        let statusHeight = UIApplication.shared.statusBarFrame.height
        let navHeight = navigationController?.navigationBar.frame.height ?? 0
        let top = statusHeight + navHeight
        mainTableView.frame = .init(x: 0, y: top, width: view.frame.width, height: view.frame.height - top)
        mainTableView.backgroundColor = UIColor.white
        mainTableView.rowHeight = 40
        mainTableView.estimatedSectionFooterHeight = 0
        mainTableView.estimatedSectionHeaderHeight = 50
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(mainTableView)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].list.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.section].list[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "cell")
        if header == nil {
            header = UITableViewHeaderFooterView.init(reuseIdentifier: "cell")
            header?.textLabel?.font = UIFont.systemFont(ofSize: 16)
            header?.backgroundColor = UIColor.gray
        }
        header?.textLabel?.text = dataSource[section].title
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.filterName = dataSource[indexPath.section].list[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

