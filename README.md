
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
└── README.md                                    # This file
```

## Setting Up and Running the Project

### 1. Running the Arduino Code

1. Open `IMU_Classifier2/MobileAssignment_for_BMI270_BMM150.ino` in **Arduino IDE**（if you use LSM9DS1，please use other one）
2. Connect your **Arduino Board** via USB.
3. Ensure that the required **BMI270 and BMM150** sensor libraries are installed.
4. Select the appropriate **board** and **port** from Arduino IDE.
5. Click **Upload** to flash the firmware to your Arduino.



### 2 Running the Application

#### 2.1 Use release apk

#### **use apk**

- Please find the installer file in release and install it on your phone.


#### 2.1 Build from source code

#### **Prerequisites**
- windos10/11
- Install **Flutter** and **Dart**: Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- Ensure **Android Studio** or **Visual Studio Code** is installed for development.
- Install the necessary dependencies by running:

  ```sh
  cd teamwork20253-main\teamapp
  flutter pub get
  ```

#### **Starting the App**
1. Navigate to the Flutter project directory:

   ```sh
   cd teamwork20253-main\teamapp
   ```

2. Connect an Android/iOS device or start an emulator.
3. Run the app:

   ```sh
   flutter run
   ```

### 3. Connecting to Bluetooth Device

- The app uses **Flutter Blue Plus** to connect to an external Bluetooth device.
- On the **Bluetooth Page**, search for available devices and connect to the correct Arduino device.
- Ensure the device is named **"Lee"**.
- After connecting, press the **"NOTIFY"** button on **f43b1...** to start receiving real-time movement classification data.

### 4. Understanding the UI

- **Home Page:** Displays movement classification results.
- **Bluetooth Page:** Allows connecting to the Arduino device.
- **Information Page:** Shows details about the team and project usage.

---

## Authors
- **Lee**
- **B**
- **Han**
- **Tee**
- **Huawei**

---

