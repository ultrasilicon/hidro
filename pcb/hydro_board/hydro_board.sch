EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Seeeduino:SeeeduinoXIAO U?
U 1 1 60A4ADD4
P 5600 2850
F 0 "U?" H 5575 1911 50  0000 C CNN
F 1 "SeeeduinoXIAO" H 5575 1820 50  0000 C CNN
F 2 "" H 5250 3050 50  0001 C CNN
F 3 "" H 5250 3050 50  0001 C CNN
	1    5600 2850
	1    0    0    -1  
$EndComp
$Comp
L Connector:Raspberry_Pi_2_3 J?
U 1 1 60ABEAF1
P 9100 3100
F 0 "J?" H 9100 4581 50  0000 C CNN
F 1 "Raspberry_Pi_2_3" H 9100 4490 50  0000 C CNN
F 2 "" H 9100 3100 50  0001 C CNN
F 3 "https://www.raspberrypi.org/documentation/hardware/raspberrypi/schematics/rpi_SCH_3bplus_1p0_reduced.pdf" H 9100 3100 50  0001 C CNN
	1    9100 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	8900 1800 8900 1250
Wire Wire Line
	8900 1250 6950 1250
Wire Wire Line
	6950 1250 6950 2400
Wire Wire Line
	6950 2400 6400 2400
Wire Wire Line
	6950 4400 6950 2550
Wire Wire Line
	6950 2550 6400 2550
Wire Wire Line
	6950 4400 8700 4400
Wire Wire Line
	8300 2200 7500 2200
Wire Wire Line
	7500 2200 7500 3300
Wire Wire Line
	7500 3300 6400 3300
Wire Wire Line
	8300 2300 7600 2300
Wire Wire Line
	7600 2300 7600 3950
Wire Wire Line
	7600 3950 4500 3950
Wire Wire Line
	4500 3950 4500 3300
Wire Wire Line
	4500 3300 4750 3300
$EndSCHEMATC
