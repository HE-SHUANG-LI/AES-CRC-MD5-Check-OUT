// include the library:
#include <spartan-edge-esp32-boot.h>
#include "ESP32IniFile.h"
#include <sea_esp32_qspi.h>
// initialize the spartan_edge_esp32_boot library
spartan_edge_esp32_boot esp32Cla;

const size_t bufferLen = 80;
char buffer[bufferLen];
char buffer1[bufferLen];
// the setup routine runs once when you press reset:
void setup() {
  // initialization 
  esp32Cla.begin();
  Serial.begin(115200);
  // check the .ini file exist or not
  const char *filename = "/board_config.ini";
  IniFile ini(filename);
  if (!ini.open()) {
    Serial.print("Ini file ");
    Serial.print(filename);
    Serial.println(" does not exist");
    return;
  }
  Serial.println("Ini file exists");

  // check the .ini file valid or not
  if (!ini.validate(buffer, bufferLen)) {
    Serial.print("ini file ");
    Serial.print(ini.getFilename());
    Serial.print(" not valid: ");
    return;
  }

  // Fetch a value from a key which is present
  if (ini.getValue("Overlay_List_Info", "Overlay_Dir", buffer, bufferLen)) {
    Serial.print("section 'Overlay_List_Info' has an entry 'Overlay_Dir' with value ");
    Serial.println(buffer);
  }
  else {
    Serial.print("Could not read 'Overlay_List_Info' from section 'Overlay_Dir', error was ");
  }

  // Fetch a value from a key which is present
  if (ini.getValue("Board_Setup", "overlay_on_boot", buffer1, bufferLen)) {
    Serial.print("section 'Board_Setup' has an entry 'overlay_on_boot' with value ");
    Serial.println(buffer1);
  }
  else {
    Serial.print("Could not read 'Board_Setup' from section 'overlay_on_boot', error was ");
  }

  // Splicing characters
  strcat(buffer,buffer1);
  
  // XFPGA pin Initialize
  esp32Cla.xfpgaGPIOInit();

  // loading the bitstream
  esp32Cla.xlibsSstream(buffer);
  SeaTrans.begin();
  uint8_t data2[16] = {0};
  uint8_t data1 = 10; //读入数据
  delay(100);
  SeaTrans.write(96, data1);
  delay(1000);
  SeaTrans.read(2, data2, 16);
  Serial.printf("Cipher Text:%x%x %x%x %x%x %x%x %x%x %x%x %x%x %x%x\r\n",data2[15],data2[14],
  data2[13],data2[12],data2[11],data2[10],data2[9],data2[8],data2[7],data2[6],data2[5],data2[4],data2[3],data2[2],data2[1],data2[0]);
}


// the loop routine runs over and over again forever:
void loop() {
}
