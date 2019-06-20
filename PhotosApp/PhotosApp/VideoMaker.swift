//
//  VideoMaker.swift
//  PhotosApp
//
//  Created by 조재흥 on 19. 6. 18..
//  Copyright © 2019 hngfu. All rights reserved.
//

import Foundation
import Photos

class VideoMaker {
    private let width: Int
    private let height: Int
    private let second: Int
    private let timescale = 600
    
    init(width: Int, height: Int, second: Int) {
        self.width = width
        self.height = height
        self.second = second
    }
    
    func makeVideo(from images: [UIImage]) {
        let fileName = "temp.mov"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: url)
        
        guard let videoWriter = try? AVAssetWriter(url: url, fileType: .mov) else { return }
        let videoSetting: [String: Any] = [AVVideoCodecKey: AVVideoCodecType.h264,
                                           AVVideoWidthKey: width,
                                           AVVideoHeightKey: height]
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSetting)
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput,
                                                           sourcePixelBufferAttributes: nil)
        videoWriter.add(writerInput)
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: .zero)
        
        let playTime = CMTimeMake(value: Int64(second * 600 / images.count), timescale: 600)
        var count = 0
        while count < images.count {
            if writerInput.isReadyForMoreMediaData,
                let buffer = pixelBuffer(from: images[count].cgImage) {
                let presentTime = CMTimeMultiply(playTime, multiplier: Int32(count))
                adaptor.append(buffer, withPresentationTime: presentTime)
                count += 1
            }
        }
        writerInput.markAsFinished()
        videoWriter.finishWriting {
            if videoWriter.status == .completed {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                }, completionHandler: nil)
            }
        }
    }

    private func pixelBuffer(from image: CGImage?) -> CVPixelBuffer? {
        guard let image = image else { return nil }
        let option = [kCVPixelBufferCGImageCompatibilityKey: true,
                      kCVPixelBufferCGBitmapContextCompatibilityKey: true,]
        var pxbuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault,
                            width,
                            height,
                            kCVPixelFormatType_32ARGB,
                            option as CFDictionary,
                            &pxbuffer)
        
        guard let buffer = pxbuffer else { return nil }
        CVPixelBufferLockBaseAddress(buffer, .init(rawValue: 0))
        guard let context = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else { return nil }
        context.concatenate(.identity)
        context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        CVPixelBufferUnlockBaseAddress(buffer, .init(rawValue: 0))
        
        return buffer
    }
}
