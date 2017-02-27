//
//  AudioManager.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/20/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import AVFoundation

enum AudioFileType: String {
    case wav = "wav"
    case m4a = "m4a"
}

class AudioManager {
    
    static let sharedInstance = AudioManager()
    
    var sounds = [String: AVAudioPlayer]()
    
    init() {
        
        let soundData: [(fileName: String, type: AudioFileType)] = [
            ("charge", AudioFileType.wav),
            ("energy-burst", AudioFileType.wav)]
        
        for data in soundData {
            if let sound = audioPlayerWithFile(file: data.fileName, type: data.type) {
                sound.prepareToPlay()
                sounds.updateValue(sound, forKey: data.fileName)
            }
        }
    }
    
    func audioPlayerWithFile(file: String, type: AudioFileType) -> AVAudioPlayer? {
        let path = Bundle.main.path(forResource: file, ofType: type.rawValue)
        let url = NSURL.fileURL(withPath: path!)
        
        var audioPlayer: AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
        } catch {
            print("Audio player not available for \(file).\(type)")
        }
        
        return audioPlayer
    }
    
    func play(_ name: String) {
        let sound = sounds[name]
        DispatchQueue.global(qos: .background).async {
            if (sound?.isPlaying)! {
                sound?.pause()
            }
            sound?.currentTime = 0
            sound?.play()
        }
    }
    
    func preInit() {
        let temp = 1.0
    }
}
