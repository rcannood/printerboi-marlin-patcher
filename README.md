# printerboi marlin patcher

This repository contains code to patch marlin firmware for printerboi, and documents custom tweaks and calibrations for the printer.

## Printerboi mods

* BigTreeTech Mini E3 V3.0 board
* 3DTouch (BLTouch clone)
* All metal hotend
* Direct drive
* Y-axis linear rail
* Belt tensioning on Z-axis
* BMG (clone) extruder ([info](https://www.youtube.com/watch?v=f2KTWnF3r1k))
* Hero Me Gen 7.4 printhead platform ([info](https://www.printables.com/model/39322-hero-me-gen-7-platform-release-4))

## Create patch

This assumes that you have a working marlin firmware for your printer.

```bash
scripts/create_patch.sh
```

## Apply patch

Apply a previously created patch to a marlin firmware.

```bash
scripts/apply_patch.sh
```

## Marlin custom settings

### BigTreeTech Mini E3 V3.0 board

We use the `Configuration/config/examples/Creality/Ender-3/BigTreeTech SKR Mini E3 3.0/*` config files as a base config by copying them to `Marlin/*`.

### Customisations

Enable some nice to have features.

In `Configuration.h`:

```diff
-#define STRING_CONFIG_H_AUTHOR "(BigTreeTech, SKR-mini-E3-V3.0)" // Who made the changes.
+#define STRING_CONFIG_H_AUTHOR "(rcannood, SKR-mini-E3-V3.0)" // Who made the changes.

-#define CUSTOM_MACHINE_NAME "Ender-3"
+#define CUSTOM_MACHINE_NAME "Printerboi"
```

In `Configuration_adv.h`:

```diff
-  //#define PROBE_OFFSET_WIZARD       // Add a Probe Z Offset calibration option to the LCD menu
+  #define PROBE_OFFSET_WIZARD       // Add a Probe Z Offset calibration option to the LCD menu

-  //#define BABYSTEP_ZPROBE_OFFSET          // Combine M851 Z and Babystepping
+  #define BABYSTEP_ZPROBE_OFFSET          // Combine M851 Z and Babystepping
```

### 3DTouch (BLTouch clone)

We enable the following settings in `Configuration.h`:

```diff
-//#define USE_PROBE_FOR_Z_HOMING
+#define USE_PROBE_FOR_Z_HOMING

-//#define BLTOUCH
+#define BLTOUCH

-#define NOZZLE_TO_PROBE_OFFSET { -40, -10, -1.85 }
+#define NOZZLE_TO_PROBE_OFFSET { -42, -10, -2.72 }

-//#define AUTO_BED_LEVELING_BILINEAR
+#define AUTO_BED_LEVELING_BILINEAR

-#define MESH_BED_LEVELING
+//#define MESH_BED_LEVELING

-//#define Z_SAFE_HOMING
+#define Z_SAFE_HOMING

+#define DIAG_JUMPERS_REMOVED
```

The X-Y offset was computed by measuring the distance between the nozzle and the probe tip. The Z offset was computed by enabling the `PROBE_OFFSET_WIZARD` and follow a guided process to set the probe Z offset (Configuration > Advanced Settings > Z Probe Wizard).

### 2.1.2.2 workaround

For 2.1.2.2, there seems to be an issue with `USE_PROBE_FOR_Z_HOMING` in Marlin 2.1.2.2. A potential workaround is to disable `USE_PROBE_FOR_Z_HOMING` and enabling `Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN` instead.

In `Configuration.h`:

```diff
-//#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN
+// workaround fix suggested by https://github.com/MarlinFirmware/Marlin/issues/23395#issue-1091284607
+#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN

-#define USE_PROBE_FOR_Z_HOMING
+// workaround fix suggested by https://github.com/MarlinFirmware/Marlin/issues/23395#issue-1091284607
+// #define USE_PROBE_FOR_Z_HOMING
```

In `Configuration_adv.h`:

```diff
-#define Z_STOP_PIN                          PC2   // Z-STOP
+// workaround fix suggested by https://github.com/MarlinFirmware/Marlin/issues/23395#issue-1091284607
+#define Z_STOP_PIN                          PC14   // Z-STOP
```

### BMG extruder

We enable the following settings in `Configuration.h`:

```diff
-#define DEFAULT_AXIS_STEPS_PER_UNIT   { 80, 80, 400, 93 }
+#define DEFAULT_AXIS_STEPS_PER_UNIT   { 80, 80, 400, 426 }
```

The extruder steps per unit was computed by printing attaching a piece of tape at 120mm distance from the extruder and extruding 100mm of filament. The extruder steps was computed by dividing the expected extrusion length by the actual extrusion length.

```r
expected_extrusion_mm <- 100
orig_tape_distance_mm <- 120
final_tape_distance_mm <- 23
orig_steps_per_mm <- 440

actual_extrusion_mm <- orig_tape_distance_mm - final_tape_distance_mm
multiplier <- expected_extrusion_mm / actual_extrusion_mm
orig_steps_per_mm / multiplier # 426
```

And in `Configuration_adv.h`:

```diff
-  #define LIN_ADVANCE_K 0.0    // Unit: mm compression per 1mm/s extruder speed
+  #define LIN_ADVANCE_K 0.776    // Unit: mm compression per 1mm/s extruder speed
```

The linear advance K was computed by printing a [calibration tower](https://github.com/SoftFever/OrcaSlicer/wiki/Calibration#tower-method) and measuring the optimal height along different corners of the tower.

```r
pa_step <- .004 # pa increase for every 1mm increase in height
optimal_heights_mm <- c(18, 20, 21, 20, 18)
mean(optimal_heights) * pa_step # 0.776
```
