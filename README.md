# Embedded Temp Controller
This project represents a digital thermostat implemented on the 8051 microcontroller, which measures the temperature using an external analog-to-digital converter (ADC), displays the values on an LCD display, and controls a relay based on the temperature set by the user.

## 🔧General functionality
- Temperature measurement via external ADC (8 bits).
- Display of current temperature and set temperature on 16x2 LCD.
- Adjustment of set temperature with 2 buttons (+ and -).
- Control of a relay (e.g. for heating/cooling).
- Code written in C language and partially in ASM.
- Full simulation in **Proteus**.
## 📦 Project structure
.\
├── keil/ &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;&nbsp;# Keil uVision source code and project files\
│ ├── codc.c &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;# Project written in C code\
│ ├── codasm.a51 &emsp;&emsp;&emsp;&emsp;&emsp;&nbsp;&nbsp;# Project written in ASM code (This one is recommended)\
│ ├── TempController.uvproj &emsp;# Keil project files\
│ └── Objects/, Listings/... &emsp;&emsp;&nbsp;# Automatic created after launching Keil\
└── TempController.pdsprj &emsp;&nbsp;&nbsp;&nbsp;# Proteus simulation

## 🖥️ Hardware
- **Microcontroller**: AT89C51 (8051 compatible)
- **Display**: 16x2 LCD, connected to port P2
- **ADC**(ADC0808): 8-bit analog-to-digital converter (e.g. ADC0804), connected to P1
- **ADC flags**: 
  - Output Enable(`OE`) on pin `P3.7`, 
  - Start Conversion(`Start`) on pin `P3.6`, 
  - End Of Conversion(`EOC`) on pin `P3.5`
- **Button Plus**: `B_Plus` – increases the set temperature, input on `P3.2`
- **Button Minus**: `B_Minus` – decreases the set temperature, input on `P3.3`
- **Relay**: controlled by μC output on `P0.3`
## ⚙️ Operation
1. When turned on, the temperature is set to `21.0°C` by default.
2. The LCD displays:
- Current temperature (`Temp:`)
- Set temperature (`Set:`)
3. The user can adjust the desired temperature with the `+` and `-` buttons.
4. If the current temperature is below the set temperature (with configurable tolerance), the relay is activated.
5. If the current temperature exceeds the set threshold, the relay is deactivated.
## 🧪 Simulation
For testing:
1. Open the file `TempController.pdsprj` in **Proteus 8.13**.
2. Make sure you have the HEX generated from Keil (`hexfile.hex`) loaded into the microcontroller.
3. Run the simulation to observe the behavior of the LCD, ADC and relay.
## 📸Screenshots
![Proteus Screenshot]("https://github.com/user-attachments/assets/dec81e6f-746a-4980-90ea-dbe84f07edd3")
## 🧠 Author
Project made for university discipline / educational hobby, for demonstration purposes.

---
## 📜License
Copyright (c) 2025 AmicuLL\
This project is provided "as is" for educational purposes. You are free to use, modify, and distribute the code as long as you credit the source.
