
#include <Arduino_LSM9DS1.h>
#include <ArduinoBLE.h>

#include <TensorFlowLite.h>
#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/schema/schema_generated.h"

#include "model.h"

const int numSamples = 150;

int samplesRead = 0;

// pull in all the TFLM ops, you can remove this line and
// only pull in the TFLM ops you need, if would like to reduce
// the compiled size of the sketch.
tflite::AllOpsResolver tflOpsResolver;

const tflite::Model* tflModel = nullptr;
tflite::MicroInterpreter* tflInterpreter = nullptr;
TfLiteTensor* tflInputTensor = nullptr;
TfLiteTensor* tflOutputTensor = nullptr;

// Create a static memory buffer for TFLM, the size may need to
// be adjusted based on the model you are using
constexpr int tensorArenaSize = 8 * 1024;
byte tensorArena[tensorArenaSize] __attribute__((aligned(16)));

// array to map gesture index to a name
const char* GESTURES[] = {
  "Running",
  "Walking",
  "idle"
};

#define NUM_GESTURES (sizeof(GESTURES) / sizeof(GESTURES[0]))

//Add BLE Service
BLEService imuService("f439b1ef-1704-4d7a-b02b-c42d5c656093");
BLEStringCharacteristic imuCharacteristic("368db6e6-9530-4966-9a1d-8bf78cc18651", BLERead | BLENotify , 32);

void onBLEConnected(BLEDevice central) {
  Serial.print("Connected to central: ");
  Serial.println(central.address());
}

void onBLEDisconnected(BLEDevice central) {
  Serial.print("Disconnected from central: ");
  Serial.println(central.address());
}

void setup() {
  Serial.begin(9600);
  while (!Serial);


  //Initialise BLE 

  if (!BLE.begin()) {
    Serial.println("Failed to initialise BLE!");

    while (1);
  }

  // //Print Mac address
  // Serial.print("Mac address: ");
  // Serial.println(BLE.address());
  // Serial.println("BLE initialised successfully");

  //Congure BLE for arduino nano 33
  BLE.setLocalName("Nano33");
  BLE.setAdvertisedService(imuService);
  imuService.addCharacteristic(imuCharacteristic);
  BLE.addService(imuService);
  BLE.advertise();

  delay(100);

  if(!BLE.advertise()){
    Serial.println("Failed to start advertising!");
  } else {
    Serial.println("BLE is now advertising...");
  }

  // initialize the IMU
  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1);
  }

  // print out the samples rates of the IMUs
  Serial.print("Accelerometer sample rate = ");
  Serial.print(IMU.accelerationSampleRate());
  Serial.println(" Hz");

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
  BLE.poll(); // Ensure BLE events are handled at the start of each loop cycle
  delay(10);

  float aX, aY, aZ;

  if (samplesRead < numSamples) {
    if (IMU.accelerationAvailable()) {
      IMU.readAcceleration(aX, aY, aZ);
      tflInputTensor->data.f[samplesRead * 3 + 0] = aX;
      tflInputTensor->data.f[samplesRead * 3 + 1] = aY;
      tflInputTensor->data.f[samplesRead * 3 + 2] = aZ;
      samplesRead++;
    }
  }

  if (samplesRead == numSamples) {
    TfLiteStatus invokeStatus = tflInterpreter->Invoke();
    if (invokeStatus != kTfLiteOk) {
      Serial.println("Invoke failed!");
      while (1);
      return;
    }

    char result[31];
    snprintf(result, sizeof(result), "R:%.2f W:%.2f I:%.2f",
            tflOutputTensor->data.f[0],
            tflOutputTensor->data.f[1],
            tflOutputTensor->data.f[2]);
    imuCharacteristic.writeValue(result);
    Serial.println(result);
    samplesRead = 0;
  }

  
}

