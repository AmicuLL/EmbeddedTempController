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
![Proteus Screenshot](https://private-user-images.githubusercontent.com/131901499/467765122-e6d2a9e5-67d6-45b9-a751-0f07ef6dfc6c.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTI3ODk1MDgsIm5iZiI6MTc1Mjc4OTIwOCwicGF0aCI6Ii8xMzE5MDE0OTkvNDY3NzY1MTIyLWU2ZDJhOWU1LTY3ZDYtNDViOS1hNzUxLTBmMDdlZjZkZmM2Yy5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNzE3JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDcxN1QyMTUzMjhaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT05YjY3YjFkNjc1YzA5YTk5NTBkMmVlY2Y2NjQzOWM5NzY4ZGE5ZWE1NGZkZDEyMDk2YjA2ZTg0NzQwNGQ5Yjg0JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.6C0qSS8avwsaJ3xNLRslQOiR5RX6ArA5s90y_WpaOrg)
![Proteus ProjectRelayOff Screenshot](https://private-user-images.githubusercontent.com/131901499/467766871-f1de52d1-3db8-477a-97f0-c4b565f8fc28.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTI3ODk4OTEsIm5iZiI6MTc1Mjc4OTU5MSwicGF0aCI6Ii8xMzE5MDE0OTkvNDY3NzY2ODcxLWYxZGU1MmQxLTNkYjgtNDc3YS05N2YwLWM0YjU2NWY4ZmMyOC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNzE3JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDcxN1QyMTU5NTFaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT0xZjIxY2FiZGEyOTQ1MDcxODVjOGEyMGQxZmY1MjAyM2IzNDYyNTg5YzM5NTQwMmUwZDYzMjI0NmY2OWUzOWIxJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.eN9i72tWGwcjvpQV3vQmUKoxs2C3Ty91CtW-oVC0gvc)
![Proteus ProjectRelayOn Screenshot](https://private-user-images.githubusercontent.com/131901499/467767274-70d62772-7105-4a80-b37f-6cda6b7e1dd8.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NTI3ODk5ODUsIm5iZiI6MTc1Mjc4OTY4NSwicGF0aCI6Ii8xMzE5MDE0OTkvNDY3NzY3Mjc0LTcwZDYyNzcyLTcxMDUtNGE4MC1iMzdmLTZjZGE2YjdlMWRkOC5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwNzE3JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDcxN1QyMjAxMjVaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1mMmJhMmM0MGUzZjM2ZDQ3MzY3OGY5OWVkNTI0NjVkZWIwNTJhNWUxNDkxZTRmOTA0NjBmNmY4NjQyZTg3YzQwJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.bez_eY3sxMRk4tDfkirgoLpmf-krCRQs0UR2xhGtBlE)
## 🧠 Author
Project made for university discipline / educational hobby, for demonstration purposes.

---
## 📜License
Copyright (c) 2025 AmicuLL\
This project is provided "as is" for educational purposes. You are free to use, modify, and distribute the code as long as you credit the source.
