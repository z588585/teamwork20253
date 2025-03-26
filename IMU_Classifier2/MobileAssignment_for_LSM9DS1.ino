#include <Arduino_LSM9DS1.h>
//#include <Arduino_BMI270_BMM150.h>
#include <TensorFlowLite.h>
#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/schema/schema_generated.h"

#include "model.h"
#include <ArduinoBLE.h>

const int numSamples = 150;

int samplesRead = 0;

tflite::AllOpsResolver tflOpsResolver;

const tflite::Model* tflModel = nullptr;
tflite::MicroInterpreter* tflInterpreter = nullptr;
TfLiteTensor* tflInputTensor = nullptr;
TfLiteTensor* tflOutputTensor = nullptr;

constexpr int tensorArenaSize =32 * 1024;
byte tensorArena[tensorArenaSize] __attribute__((aligned(16)));

// array to map gesture index to a name
const char* GESTURES[] = {
  "Run",
  "walk",
  "Stationary"
};

#define NUM_GESTURES (sizeof(GESTURES) / sizeof(GESTURES[0]))

BLEService* imuService = nullptr;
BLECharacteristic* imuCharacteristic = nullptr;
// BLEByteCharacteristic* imuCharacteristic = nullptr;
// static BLEService imuService("f439b1ef-1704-4d7a-b02b-c42d5c656093");
// static BLEByteCharacteristic imuCharacteristic("368db6e6-9530-4966-9a1d-8bf78cc18651", BLERead | BLENotify);

void setup() {
  imuService = new BLEService("f439b1ef-1704-4d7a-b02b-c42d5c656093");
  // imuCharacteristic = new BLEByteCharacteristic("368db6e6-9530-4966-9a1d-8bf78cc18651", BLERead | BLENotify);
  imuCharacteristic = new BLECharacteristic("368db6e6-9530-4966-9a1d-8bf78cc18651", BLERead | BLENotify, 3);
  // put your setup code here, to run once:
  Serial.begin(9600);
  unsigned long serialTimeout = millis();
  while (!Serial && (millis() - serialTimeout < 3000));  // 最多等待 3 秒

  //BLE SETUP-----------------------------------------
  if(!BLE.begin()){
    Serial.println("Staring bluetooth failed...");
    while(1);
  }

  BLE.setLocalName("Lee");
  BLE.setAdvertisedService(*imuService);
  imuService->addCharacteristic(*imuCharacteristic);
  BLE.addService(*imuService);
  imuCharacteristic->writeValue(byte(0));
  BLE.advertise();
  Serial.println("Bluetooth device active, waiting for connections...");

  //BLE SETUP-----------------------------------------
  // initialize the IMU
  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1);
  }

  // print out the samples rates of the IMUs
  // Serial.print("Accelerometer sample rate = ");
  // Serial.print(IMU.accelerationSampleRate());
  // Serial.println(" Hz");

  // Serial.println();

  // get the TFL representation of the model byte array
  tflModel = tflite::GetModel(model);
  if (tflModel->version() != TFLITE_SCHEMA_VERSION) {
    Serial.println("Model schema mismatch!");
    return;
  }

  // Create an interpreter to run the model
  tflInterpreter = new tflite::MicroInterpreter(tflModel, tflOpsResolver, tensorArena, tensorArenaSize);


  // Allocate memory from the tensor_arena for the model's tensors.
  TfLiteStatus allocate_status = tflInterpreter->AllocateTensors();
  if (allocate_status != kTfLiteOk) {
    MicroPrintf("AllocateTensors() failed");
    return;
  }

  // Get pointers for the model's input and output tensors
  tflInputTensor = tflInterpreter->input(0);
  tflOutputTensor = tflInterpreter->output(0);

}

void loop() {
  //poll for bluetooth
  BLE.poll();
  // put your main code here, to run repeatedly:
  float aX, aY, aZ;
  if(samplesRead < numSamples){
    if(IMU.accelerationAvailable()){
      IMU.readAcceleration(aX, aY, aZ);
      // Serial.println(samplesRead);
      tflInputTensor->data.f[samplesRead * 3 + 0] = aX;
      tflInputTensor->data.f[samplesRead * 3 + 1] = aY;
      tflInputTensor->data.f[samplesRead * 3 + 2] = aZ;
      samplesRead++;
    }
  }

  if (samplesRead == numSamples) {
    // Run inferencing
    // Serial.println("Boo1");
    TfLiteStatus invokeStatus = tflInterpreter->Invoke();
    // Serial.println(invokeStatus);
    // Serial.println("Boo");
    if (invokeStatus != kTfLiteOk) {
      Serial.println("Invoke failed!");
      // samplesRead = 0;
      while (1);
      return;
    }


    // Serial.println("boo3");
    int maxIndex = 0;
    float maxValue = tflOutputTensor->data.f[0];
    for (int i = 1; i < NUM_GESTURES; i++) {
      if (tflOutputTensor->data.f[i] > maxValue) {
        maxValue = tflOutputTensor->data.f[i];
        maxIndex = i;
      }
    }

    // 将 maxValue 乘以 1000 并转换为整数
    // Multiply maxValue by 1000 and convert to an integer
    int16_t maxValueInt = static_cast<int16_t>(maxValue * 1000);

    // 创建一个 3 字节的数据包, 第一个字节存储 maxIndex, 后两个字节存储 maxValueInt
    // 例如, 如果 maxIndex 是 1, maxValueInt 是 1234, 那么数据包是 {1, 210, 4}
    // Create a 3-byte data packet, first byte stores maxIndex, next two bytes store maxValueInt
    // For example, if maxIndex is 1, maxValueInt is 1234, then the data packet is {1, 210, 4}
    byte dataPacket[3];
    dataPacket[0] = static_cast<byte>(maxIndex); // 第一个字节存储 maxIndex ， First byte stores maxIndex
    dataPacket[1] = static_cast<byte>(maxValueInt & 0xFF); // 低字节， Low byte
    dataPacket[2] = static_cast<byte>((maxValueInt >> 8) & 0xFF); // 高字节， High byte

    // 发送数据 Send data
    imuCharacteristic->writeValue(dataPacket, sizeof(dataPacket));

    Serial.print("Sent Data - Index: ");
    Serial.print(maxIndex);
    Serial.print(", Value: ");
    Serial.println(maxValueInt);

    // Serial.println();
    samplesRead = 0;
  }
}
   // // Loop through the output tensor values from the model
    // for (int i = 0; i < NUM_GESTURES; i++) {
    //   Serial.print(GESTURES[i]);
    //   Serial.print(": ");
    //   Serial.println(tflOutputTensor->data.f[i], 6);
    // }

    // Clean up the data buffer before filling up for the next batch.