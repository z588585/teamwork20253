Sure! Here's the full English translation of your documentation:

---

# TeamApp - IMU Classifier

## Project Structure

```
teamwork20253-main\
│
├── IMU_Classifier2\
│   ├── MobileAssignment_for_BMI270_BMM150.ino   # Arduino source code
│
├── teamapp\
│   ├── lib\
│   │   ├── main.dart                            # Flutter main application file
│   ├── pubspec.yaml                             # Flutter project dependencies
│   ├── android/                                 # Android build files
│   ├── ios/                                     # iOS build files
│   ├── assets/                                  # Images, fonts, and other resources
│   ├── build/                                   # Compiled build output
│   ├── test/                                    # Testing files
│
├── app.apk                                      # app install apk
├── flutter-apk.zip                              # all apk
│
└── README.md                                    # This file
```

## Setting Up and Running the Project

### 1. Running the Arduino Code

1. Open `IMU_Classifier2/MobileAssignment_for_BMI270_BMM150.ino` in **Arduino IDE** (if you're using LSM9DS1, please use the other version).
2. Connect your **Arduino Board** via USB.
3. Make sure the required **BMI270 and BMM150** sensor libraries are installed.
4. Select the appropriate **board** and **port** in the Arduino IDE.
5. Click **Upload** to flash the firmware to your Arduino device.

---

### 2. Running the Application

#### 2.1 Using the Release APK

- Please locate the installer file in the release section and install it on your phone.

#### 2.2 Building from Source

##### **Prerequisites**

- Windows 10/11
- Install **Flutter** and **Dart**: Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- Ensure **Android Studio** or **Visual Studio Code** is installed for development.
- Install necessary dependencies by running:

  ```sh
  cd teamwork20253-main\teamapp
  flutter pub get
  ```

##### **Starting the App**

1. Navigate to the Flutter project directory:

   ```sh
   cd teamwork20253-main\teamapp
   ```

2. Connect an Android/iOS device or start an emulator.
3. Run the app:

   ```sh
   flutter run
   ```

---

### 3. Connecting to the Bluetooth Device

- The app uses **Flutter Blue Plus** to connect to an external Bluetooth device.
- On the **Bluetooth Page**, search for available devices and connect to the correct Arduino board.
- Make sure the device name is **"Lee"**.
- After connecting, press the **"NOTIFY"** button under the **f43b1...** characteristic to start receiving real-time movement classification data.

---

### 4. Understanding the UI

- **Home Page:** Displays movement classification results and current calorie consumption.
- **Bluetooth Page:** Allows connection to the Arduino device.
- **Information Page:** Provides details about the team and usage instructions.
- **Map Page:** Displays a map with the user’s traveled route and total distance.  
  Different colors represent movement states:  
  - **Red** for running  
  - **Blue** for walking  
  A **clear button** is located at the bottom-left corner to reset the tracking data.

---

## Authors

- **Lee**
- **B**
- **Han**
- **Tee**
- **Huawei**

--- 

Let me know if you'd like a stylized markdown version or a downloadable file too!


