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
    case mp3 = "mp3"
}

class AudioManager {
    
    static let sharedInstance = AudioManager()
    
    var sounds = [String: AVAudioPlayer]()
    var isSoundOn: Bool!
    
    init() {
        
        let soundData: [(fileName: String, type: AudioFileType)] = [
            ("charge", AudioFileType.wav),
            ("energy-burst", AudioFileType.wav),
            ("beep-low", AudioFileType.wav),
            ("beep-high", AudioFileType.wav),
            ("phase-death", AudioFileType.wav),
            ("shell-move", AudioFileType.wav),
            ("chirp", AudioFileType.wav),
            ("energy-up", AudioFileType.wav),
            ("menu-beeping", AudioFileType.wav),
            ("music", AudioFileType.mp3),
            ("laser-charge", AudioFileType.wav),
            ("creeping-death-drone", AudioFileType.wav),
            ("bump", AudioFileType.wav)]
        
        for data in soundData {
            if let sound = audioPlayerWithFile(file: data.fileName, type: data.type) {
                sound.prepareToPlay()
                sounds.updateValue(sound, forKey: data.fileName)
            }
        }
        
        // Get sound state
        let userDefaults = UserDefaults.standard
        if let value = userDefaults.object(forKey: "isSoundOn") {
            isSoundOn = value as! Bool
        } else {
            isSoundOn = true
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
        if isSoundOn == true {
            let sound = sounds[name]
            DispatchQueue.global(qos: .background).async {
                if (sound?.isPlaying)! {
                    sound?.pause()
                }
                sound?.currentTime = 0
                sound?.play()
            }
        }
    }
    
    func playLoop(_ name: String) {
        if isSoundOn == true {
            let sound = sounds[name]
            DispatchQueue.global(qos: .background).async {
                if (sound?.isPlaying)! {
                    sound?.pause()
                }
                sound?.currentTime = 0
                sound?.numberOfLoops = -1
                sound?.play()
            }
        }
    }
    
    func stop(_ name: String) {
        let sound = sounds[name]
        DispatchQueue.global(qos: .background).async {
            if (sound?.isPlaying)! {
                sound?.pause()
                sound?.currentTime = 0
            }
        }
    }
    
    func setVolume(_ name: String, volume: Float, dur: TimeInterval) {
        let sound = sounds[name]
        DispatchQueue.global(qos: .background).async {
            sound?.setVolume(volume, fadeDuration: dur)
        }
    }
    
    func incrementVolume(_ name: String, increment: Float, dur: TimeInterval) {
        let sound = sounds[name]
        DispatchQueue.global(qos: .background).async {
            var newVol = (sound?.volume)! + increment
            if (newVol > 1.0) { newVol = 1.0 }
            if (newVol < 0.0) { newVol = 0.0 }
            sound?.setVolume(newVol, fadeDuration: dur)
            print(newVol)
        }
    }
    
    func toggleSound() {
        // Stop or play sounds
        if self.isSoundOn {
            for soundName in sounds.keys {
                stop(soundName)
            }
        } else {
            playLoop("menu-beeping")
            playLoop("music")
            setVolume("music", volume: 0.9, dur: 0)
        }
        
        // Update settings
        let userDefaults = UserDefaults.standard
        userDefaults.set(!isSoundOn, forKey: "isSoundOn")
        isSoundOn = !isSoundOn
    }
    
    func preInit() {
        _ = 0
    }
}
