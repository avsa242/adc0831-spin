# adc0831-spin 
--------------

This is a P8X32A/Propeller, P2X8C4M64P/Propeller 2 driver object for the TI ADC083x-series ADCs.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.


## Salient Features

* P1: SPI (R/O, 80MHz Fsys) connection at 26kHz (FlexSpin bytecode backend) or up to 400kHz (FlexSpin PASM backend)
* P2: SPI (R/O, 180MHz Fsys) connection at up to 400kHz (PASM)
* Read ADC word
* Read voltage in microvolts
* SCK frequency changeable at any time between samples, and adapts to current system clock (P1 only using PASM builds, or P2)

## Requirements

P1/SPIN1:
* spin-standard-library
* signal.adc.common.spinh (provided by spin-standard-library)

P2/SPIN2:
* p2-spin-standard-library
* signal.adc.common.spin2h (provided by p2-spin-standard-library)


## Compiler Compatibility

| Processor | Language | Compiler               | Backend      | Status                |
|-----------|----------|------------------------|--------------|-----------------------|
| P1	    | SPIN1    | FlexSpin (6.2.1)	| Bytecode     | OK                    |
| P1	    | SPIN1    | FlexSpin (6.2.1)       | Native/PASM  | OK                    |
| P2	    | SPIN2    | FlexSpin (6.2.1)       | ~~NuCode~~   | FTBFS                 |
| P2        | SPIN2    | FlexSpin (6.2.1)       | Native/PASM2 | OK                    |

(other versions or toolchains not listed are __not supported__, and _may or may not_ work)


## Hardware compatibility

* Tested with ADC0831


## Limitations

* Very early in development - may malfunction, or outright fail to build
* Untested with other models in the family, so no configurability is possible yet (read-only SPI)
* P1: Selectable bus speed only possible when building using FlexSpin's PASM backend

