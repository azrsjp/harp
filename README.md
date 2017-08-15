# harp
The name of harp project comes from harp seal.

<img src="https://cloud.githubusercontent.com/assets/443965/26057332/28d871de-39b4-11e7-88ef-a31db1b5bf56.png" width="320">

This application will be BMS Player for macOS (10.10 or newer). Currently work in progress.

# Try to play
0. Build this project
1. Launch Harp app
2. Click `Play` under `InputKeys` menu
3. Input absolute path for bms file to TextBox
4. Click `Start` button

# Roadmap
- [x] Adopt to conventional HID controller for BMS
- [x] BMS file Loader
- [x] Accuracy of Judging
- [x] Hi-Speed, lift, hid+ options
- [x] Normal, Easy, Hard, Ex-Hard Gauge type
- [x] Random, S-Random, Mirror options
- [ ] KeyConfig
- [ ] InGame UI (default theme)
- [ ] BMSFileManager(localDB)
- [ ] BMSSelector(MainMenu)
- [ ] Sound Effects System

# Environments
Clone this repository, and build under following Environments.
- Swift3.1 (Xcode8.3.2)
- SpriteKit
- CocoaPods

## Dependencies
- [ALURE v1.2](http://kcat.strangesoft.net/alure.html)
- And see Podfile
