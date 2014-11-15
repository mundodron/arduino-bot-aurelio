As of October 8th 2014, this is the absolute latest available source code for MultiWii, taken from the main repository:

https://code.google.com/p/multiwii/source/list

Use at your own risk.

Summary of changes since 2.3 release:
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

>> October 2014, Current SVN Source
r1711 : COMPASS HMC5883 code tweak
r1710 : cosmetic: reformat/standardize code indent, suppress all tab symbol
r1709 : COMPASS init and calibration code tweak
r1708 : GYRO calibration code tweak
r1707 : ACC calibration code tweak: same result, less code
r1706 : Sensors.cpp syntax tweak (better use of static)
r1705 : remove MSP ack message mainly to lower downlink BW (for instance no ack for MSP_SET_RAW_RC)
r1704 : reserved MSP for FRSKY SPORT
r1703 : fix compiler warning about double /*
r1702 : remove EOSbandi quick hack fix for wingui - not useful - save memory
r1701 : fix for coptertest=4 + sanity check: GPS requires to specify protocol UBLOX, NMEA,...
r1700 : some MPS parsing tweaking
r1699 : some ublox GPS parsing tweaking
r1698 : Added RSSI injection on a RC channel from receiver. Compatible with analog RSSI readings http://www.multiwii.com/forum/viewtopic.php?f=8&t=5530
r1697 : minor GPS frame parsing & compute task correction
r1696 : lcd.config: do not display MAG.P without MAG - lcd.telemetry page3: fix bug http://www.multiwii.com/forum/viewtopic.php?f=8&t=5527 + lcd.telemetry: make items in pages 1,2,9 user configurable
r1695 : SUMD correction (http://www.multiwii.com/forum/viewtopic.php?f=8&t=5490#p56180)
r1694 : First checkin of the GPS nav code. It is functionally identical with B7. i2c support temporary removed, will add back later.
r1693 : introduction of SUMD RX type (http://www.multiwii.com/forum/viewtopic.php?f=8&t=5490)
r1692 : B.Go.Beyond source from Witold Mielniczek for www.bgobeyond.co.uk
r1691 : Support for GY-88 https://github.com/multiwii/multiwii-firmware/pull/10
r1690 : re add #define option for: when GPS defined, only allow arm with gps 3dfix
r1689 : SBUS scaling signal (JohnB suggestion http://www.multiwii.com/forum/viewtopic.php?f=8&t=4425&start=50#p53833)
r1688 : when GPS defined, only allow arm with gps 3dfix (http://www.multiwii.com/forum/viewtopic.php?f=8&t=5406)
r1687 : minor bug gps_ublox_eeprom axis_undef (http://www.multiwii.com/forum/viewtopic.php?f=8&t=5405)
r1686 : MultiwiiConf miscellaneous fixes (http://www.multiwii.com/forum/viewtopic.php?f=8&t=5401)

>> July 2014, Previous Super-X SVN Source
1685 : ACC Nunchuk device is no more supported
1684 : MAG, HEADHOLD and HEADFREE without a magnetometer. default orientation is north. (based on this idea: http://www.multiwii.com/forum/viewtopic.php?f=8&t=5088)
1683 : Changed limits for MagDecl in Gui http://www.multiwii.com/forum/viewtopic.php?f=8&t=5298
1682 : mag calib with beeps (in previous commit, really)
1681 : prevent overflow for ampere values > 65A - transmit with 1unit==0.1A --> gui needs adaption - gui adaption to amperage resolution + compute watts and maximum watts
1679 : better accuracy for InvSqrt thanks to new coeff and 8 bytes less (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4246&p=51412#p51412)
1678 : 14 bytes less in MS baro computation (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4246&p=51412#p51412)
1676 : initial parms
1674 : FixedWing Merged with EOS Gps Nav.
1673 : Adding D7 on Mega as Servo pin for better compatibility with existing FC's
1672 : Added AmpereMeter in Gui. Increased range on TX sliders to 900 - 2100 µs on ch ch 1-4
1670 : Updated FW Nav with new I2C_GPS handling. Improved Failsafe routine for No Gps situations Corrections for OSD Data.
1669 : little optimization in sensor task order switch loop
1667 : change some MSP numbers to avoid messing up third apps (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4574&p=48497#p48160)
1666 : consider I2C_GPS as a simple GPS device like SERIAL GPS: the same code is now used for all GPS devices. (best option to keep old I2C GPS compatibility, but code size with GPS is now an issue with pro micro proc) - make HEADFREE optional - use struct to serialize GPS data in MSP part
1665 : dissociate frame parsing and frame computation for SERIAL GSP to smooth cycle loop jitter
1664 : SBUS patch (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4425&start=40#p47156)
1663 : little change for GPS_PROMINI detection
1662 : add MSP_ACC_TRIM and MSP_SET_ACC_TRIM (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4574)
1661 : assign id for MSP_PRIVATE message with no code for the moment - range [50-99] won't be used in multiwii and can therefore be used for any custom fork implementation without the risk of conflict id later
1660 : Updated FW Nav
1658 : Releese candidate of FixedWingNav code.
1653 : Added PCF8591 I2C ADC support
1651 : fusion of SBUS & SPEKTRUM PORT define (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4510)
1650 : computeRC()reevaluation (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4522)
1649 : correction of error on MS baro dealing with baroTemperature (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4534)

>> January 2014, Current DEV Release: "MultiWii_dev_2014_01_14__r1648.zip"
1648 : refine SBUS RX code (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4425&start=30#p45299)
1647 : define MSP_PROTOCOL_EXTENSION in config.h
1646 : add new MSP_CUSTOM (unused in mwi8bit)
1645 : This proposal allow a mild version of expo/rate for precision then another set for acro or more aggressive maneuvers. see https://github.com/multiwii/baseflight/pull/29 + addtionial changes : change msp rc tunning to a 11 byte payload gui updated (minimal changes)
1640 : THROTTLE_ANGLE_CORRECTION bug correction (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4433)
1639 : correction of previous mod http://www.multiwii.com/forum/viewtopic.php?f=8&t=3635&start=10#p43916 - we keep only 8/16/32 kHz
1638 : brushed motors option on 32u4 proc at 1 / 2 / 4 / 8 / 16/ 32 /64 kHz (http://www.multiwii.com/forum/viewtopic.php?f=8&t=3635&p=36883#p36877)
1637 : use only one struct 3x32 bits for each gyro+acc / gyro+mag vector
1636 : use SBUS_SERIAL_PORT (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4299#p43484)
1635 : brushed motors option on 328p at 1kHz / 4kHz / 32 kHz (http://www.multiwii.com/forum/viewtopic.php?f=8&t=3635&p=36883#p36877)
1632 : small RX UART ISR tweak
1631 : THROTTLE_ANGLE_CORRECTION correction - some timing info in the code
1630 : I2C GPS PID init settings (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4246&start=30#p43393)
1629 : MultiWii-StickConfiguration with explicit CC license info page
1628 : little tweak in getEstimatedAltitude()
1627 : MS BARO: a third state is introduced to isolate computation and smooth timecycle
1626 : unique I2C speed set once (400kHz), except for old WMP config (http://www.multiwii.com/forum/viewtopic.php?f=8&t=4270)
1625 : MS561101BA baro: use float approximation instead of int64_t intermediate values - MS561101BA baro: does not use 2nd order compensation under -15 deg - MS561101BA baro: use 16 bit deadline timer instead of 32 bit
1624 : 16 bit for baroTemperature instead of 32 bit
1623 : use asm mul16x16 function where possible in PID computation
1622 : rcTime defined as 16 bit long
1620 : small I2C function shortcut
1619 : _atan2 and InvSqrt little tweak
1618 : remove intermediate variable gyroADCp
1617 : 16 bit and non static timeInterleave
1616 : use 16x16 integer asm for baroVel too
1615 : reformat accMag condition
1614 : move accZ computation into imu main function
1613 : use optimized asm function to calculate signed 16 bit x signed 16 bit integers
1612 : use 16 bit integer for deltaGyroAngle16 instead of float
1611 : use 16 bit fix integer for ACC and MAG vectors instead of 32 bit
1610 : use intermediate 32 bit fix integer vectors to evaluate complementary filter of ACC and MAG - compute rotation on those intermediate vectors - use 32 bit fix integer for ACC and MAG vectors
1609 : move ACC_1G def and GYRO_SCALE in Sensors.h

>> November 2013, Current 2.3 Release: "MultiWii_2_3.zip"
1608 : r1607 is v2.3 2013.11.11


In addition, the following patches have been REMOVED or MERGED with the main trunk:
REMOVED Code: [FEATURE] r1685-two_stick_arm_with_timeout.patch (http://www.multiwii.com/forum/viewtopic.php?f=8&t=5407)
MERGED  GUI:  [PATCH] MultiwiiConf r1865 miscellaneous fixes (http://www.multiwii.com/forum/viewtopic.php?f=8&t=5401)

The included MultiWiiConf binary is identical to the previous 1685 release.
