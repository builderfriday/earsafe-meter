#let ink = rgb("#111315")
#let accent = rgb("#7a2414")
#let muted = rgb("#5f666b")
#let light = rgb("#b9b1a6")

#let mono = text.with(font: "Liberation Mono")
#let sans = text.with(font: "Liberation Sans")

#set text(font: "Liberation Sans", size: 10pt, fill: ink)
#set par(justify: false, leading: 0.68em)
#set page(
  paper: "us-letter",
  margin: (top: 0.82in, bottom: 0.78in, x: 0.78in),
  header: context if counter(page).get().first() > 1 [
    #set text(size: 8pt, fill: ink)
    #line(length: 100%, stroke: 0.7pt + ink)
    #v(5pt)
    #grid(
      columns: (1fr, 1fr),
      gutter: 0pt,
      [#mono(tracking: 0.05em)[EARSAFE METER V1]],
      [#align(right)[#mono(tracking: 0.05em)[TECHNICAL SPECIFICATION]]],
    )
    #v(10pt)
  ],
  footer: context if counter(page).get().first() > 1 [
    #v(8pt)
    #line(length: 100%, stroke: 0.7pt + ink)
    #v(4pt)
    #grid(
      columns: (1fr, 1fr, 1fr),
      gutter: 0pt,
      [#mono(size: 7.5pt, fill: muted, tracking: 0.05em)[DOCUMENT EM-V1]],
      [#align(center)[#mono(size: 7.5pt, fill: muted, tracking: 0.05em)[REV A]]],
      [#align(right)[#mono(size: 7.5pt, fill: muted, tracking: 0.05em)[#counter(page).display("1")]]],
    )
  ],
)

#show table.cell.where(y: 0): it => {
  set text(weight: "bold", size: 8.2pt, fill: accent)
  set par(justify: false)
  it
}

#let section(number, title) = [
  #v(4pt)
  #grid(
    columns: (86pt, 1fr),
    gutter: 10pt,
    align: horizon,
    [#mono(size: 8.5pt, fill: accent, tracking: 0.06em)[SECTION #number]],
    [#text(weight: "bold", size: 17pt)[#title]],
  )
  #v(4pt)
  #line(length: 100%, stroke: 0.8pt + ink)
  #v(11pt)
]

#let note(label, body) = block(
  inset: 10pt,
  stroke: 0.7pt + ink,
  above: 8pt,
  below: 10pt,
)[
  #mono(size: 8pt, fill: accent, tracking: 0.05em)[#label]
  #v(5pt)
  #body
]

#let spec-table(columns, ..cells) = table(
  columns: columns,
  inset: (x: 6pt, y: 5pt),
  align: (x, y) => left + horizon,
  stroke: (x, y) => if y == 0 {
    (bottom: 0.8pt + ink)
  } else {
    (bottom: 0.35pt + light)
  },
  ..cells,
)

#align(left)[
  #mono(size: 8.5pt, fill: accent, tracking: 0.06em)[TECHNICAL SPECIFICATION MANUAL]
]

#v(14pt)

#grid(
  columns: (1.2fr, 0.78fr),
  gutter: 24pt,
  [
    #text(weight: "bold", size: 28pt)[EARSAFE METER V1]
    #v(8pt)
    #text(size: 11pt, fill: muted)[Battery-powered desk sound monitor for personal sound exposure control.]
  ],
  [
    #block(
      inset: 10pt,
      stroke: 0.8pt + ink,
    )[
      #spec-table(
        (72pt, 1fr),
        [DOCUMENT], [EM-V1],
        [REVISION], [A],
        [STATUS], [INITIAL ISSUE],
        [OWNER], [BUILDERFRIDAY],
        [EXPORT], [DIRECT PDF],
      )
    ]
  ],
)

#v(20pt)
#line(length: 100%, stroke: 0.8pt + ink)
#v(14pt)

#grid(
  columns: (1fr, 0.88fr),
  gutter: 24pt,
  [
    #text(weight: "bold", size: 10pt)[Design intent]
    #v(6pt)
    - Measure room sound near the listener position.
    - Show one clear sound level value at a glance.
    - Show warning state before daily sound dose becomes excessive.
    - Run from internal battery power with USB-C charge.
  ],
  [
    #block(
      inset: 10pt,
      stroke: 0.8pt + ink,
    )[
      #align(center)[#mono(size: 8pt, fill: accent, tracking: 0.05em)[CONCEPT VIEW]]
      #v(10pt)
      #align(center)[
        #box(stroke: 0.8pt + accent, inset: 0pt)[
          #stack(
            spacing: 0pt,
            box(height: 16pt, width: 116pt)[],
            box(height: 54pt, width: 116pt, stroke: 0.8pt + accent)[],
            box(height: 18pt, width: 116pt)[],
          )
        ]
      ]
      #v(10pt)
      #align(center)[#text(size: 8pt, fill: muted)[Desk instrument enclosure, front view]]
    ]
  ],
)

#v(174pt)
#line(length: 100%, stroke: 0.8pt + ink)
#v(4pt)
#mono(size: 8pt, fill: muted, tracking: 0.05em)[PERSONAL ACOUSTIC MONITOR / FIRST ENGINEERING ISSUE]

#pagebreak()

#section([00], [Contents])

This specification defines the first build of EARSAFE METER. The device is a battery-powered desk sound monitor. It shows present sound level, warning state, peak level, and daily sound dose.

#v(8pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 30pt,
  [
    01 Purpose and Use Limits \
    02 Build of Record \
    03 Test-First Build Strategy \
    04 Hardware Configuration \
    05 Wiring and Electrical Design \
    06 Display and User Interface
  ],
  [
    07 Bench Build Recipe \
    08 Calibration and Accuracy \
    09 Enclosure Design Recipe \
    10 Final Assembly \
    11 Verification and Acceptance \
    Appendix A Shopping List
  ],
)

#note(
  [DOCUMENT INTENT],
  [This manual must stay direct. It must stay technical. It must not use web-document decoration, startup language, or sales language.]
)

#section([01], [Purpose and Use Limits])

EARSAFE METER V1 is a desk sound monitor. The device measures sound near the user position. The device shows present A-weighted sound level. The device also shows warning state, peak level, and daily sound dose.

Use the device for personal sound control during music use, speaker testing, long study sessions, and other repeated listening activity. Do not use the device as a certified legal meter. Do not use the device as the only control for industrial safety.

#note(
  [USE LIMIT],
  [The reading becomes useful only after calibration against a known reference meter. Before calibration, use the value as relative guidance.]
)

#section([02], [Build of Record])

#spec-table(
  (0.20fr, 0.34fr, 0.46fr),
  [ITEM], [FINAL PICK], [WHY THIS IS THE PICK],
  [Main board], [Seeed Studio XIAO nRF52840 Sense], [USB-C, onboard PDM microphone, onboard battery charger, very small board, official support in Arduino and CircuitPython.],
  [Display], [Waveshare 2.13 inch e-Paper HAT, black and white, 250 by 122], [Paper-like display, low power, compact board, easy SPI wiring.],
  [Battery], [Adafruit 3.7 V 2000 mAh Li-ion polymer battery, product 2011], [Known JST-PH battery, protected, compact, enough capacity for a desk device.],
  [Display alert], [Display only], [No buzzer in V1. Keep the build simpler and quieter.],
  [Wireless], [Disabled in V1], [Do not spend V1 effort on phone setup or background radio power use.],
  [Core outputs], [Current dBA, one-minute average, peak, daily dose], [These values are enough to guide listening behavior.],
)

#v(10pt)
- Keep the first build simple.
- Use one exact part for each function.
- Do not start case design before the bench tests pass.
- Do not add Wi-Fi, buzzer, or a custom PCB in V1.

#note(
  [V1 BOUNDARY],
  [This document fixes the V1 design. If a part is not listed here, do not add it to the first build. The goal is a working desk instrument, not maximum features.]
)

#section([03], [Test-First Build Strategy])

Build the device in gates. Do not move to the next gate until the current gate passes. This is the main beginner rule for the project.

#spec-table(
  (0.14fr, 0.54fr, 0.32fr),
  [GATE], [OBJECTIVE], [PASS CONDITION],
  [G-01], [Power the XIAO board from USB-C and then from the LiPo battery.], [Board boots in both cases. Charge LED works with battery connected.],
  [G-02], [Wire the e-paper display and show a static test screen.], [The display refreshes fully and shows the expected image.],
  [G-03], [Read microphone samples and print raw level data.], [Microphone values change when room sound changes.],
  [G-04], [Calculate and display current dBA, average, and peak.], [The values update in a stable and believable way.],
  [G-05], [Run calibration against a reference meter.], [Stored offset makes the display agree with the reference close enough for personal use.],
  [G-06], [Only after the above: design and print the enclosure.], [The finished hardware still passes Gates 01 to 05 after assembly.],
)

#note(
  [STOP RULE],
  [If Gate 02 fails, do not write sound-processing code. If Gate 03 fails, do not design the enclosure. If Gate 05 fails, do not trust the displayed dBA value.]
)

#section([04], [Hardware Configuration])

This section is the exact parts list for the first build. It is the build of record.

#spec-table(
  (0.08fr, 0.26fr, 0.36fr, 0.30fr),
  [LINE], [PART], [EXACT PICK], [WHAT IT DOES],
  [1], [Main controller], [Seeed Studio XIAO nRF52840 Sense], [Runs firmware, provides USB-C, provides the onboard microphone, and charges the battery.],
  [2], [Display], [Waveshare 2.13 inch e-Paper HAT, black and white], [Shows the large dBA value and all warning states.],
  [3], [Battery], [Adafruit 3.7 V 2000 mAh Li-ion polymer battery, product 2011], [Provides portable power for V1.],
  [4], [Hookup wire], [Eight short 28 AWG stranded wires], [Connects the XIAO board to the e-paper board.],
  [5], [Solder], [Lead-free rosin-core electronic solder], [Required for permanent wiring.],
  [6], [Buttons], [None for first bench build], [Use firmware defaults first. Add buttons only after the display and microphone both work.],
  [7], [Alert hardware], [None in V1], [Display state is the only alert output in V1.],
)

#v(8pt)

#spec-table(
  (0.22fr, 0.20fr, 0.18fr, 0.40fr),
  [ITEM], [DIMENSIONS], [QTY], [NOTES],
  [XIAO board], [21 by 17.8 mm], [1], [Small enough to mount behind the display.],
  [Waveshare display board], [65.0 by 30.2 mm], [1], [This is the board size, not only the visible screen.],
  [Visible display area], [48.55 by 23.71 mm], [1], [Use this for the front window cutout.],
  [Battery], [60 by 36 by 7 mm], [1], [Use this size for the first enclosure volume check.],
)

#note(
  [BEGINNER ADVICE],
  [Buy the exact parts before you design the enclosure. Do not design the case around a guessed battery size or a guessed display board size.]
)

#section([05], [Wiring and Electrical Design])

The sound enters through the digital microphone. The controller reads the signal. The firmware applies A-weighting and RMS logic. The firmware then computes present dBA, one minute average, peak, and daily dose.

#v(8pt)
#grid(
  columns: (1fr, auto, 1.2fr, auto, 1.35fr, auto, 1fr),
  column-gutter: 6pt,
  row-gutter: 6pt,
  align: center + horizon,
  [#box(stroke: 0.8pt + ink, inset: 7pt)[MIC]],
  [→],
  [#box(stroke: 0.8pt + ink, inset: 7pt)[MCU INPUT]],
  [→],
  [#box(stroke: 0.8pt + ink, inset: 7pt)[A-WEIGHT / RMS]],
  [→],
  [#box(stroke: 0.8pt + ink, inset: 7pt)[DISPLAY]],
  [#box(stroke: 0.8pt + ink, inset: 7pt)[USB-C / CELL]],
  [→],
  [#box(stroke: 0.8pt + ink, inset: 7pt)[POWER CONTROL]],
  [→],
  [#box(stroke: 0.8pt + ink, inset: 7pt)[SETTINGS / OFFSET]],
  [→],
  [#box(stroke: 0.8pt + ink, inset: 7pt)[ALERT]],
)

#v(7pt)
#text(size: 8.3pt, fill: muted)[Figure 1. The upper line shows the signal chain. The lower line shows the power and settings chain.]

#v(10pt)

#spec-table(
  (0.20fr, 0.18fr, 0.18fr, 0.44fr),
  [DISPLAY PIN], [CONNECT TO], [XIAO PIN], [COMMENT],
  [VCC], [3V3], [3V3], [Power the display from 3.3 V.],
  [GND], [Ground], [GND], [Common ground is mandatory.],
  [DIN], [SPI MOSI], [D10], [XIAO SPI data out.],
  [CLK], [SPI SCK], [D8], [XIAO SPI clock.],
  [CS], [GPIO], [D3], [Chip select for the display.],
  [DC], [GPIO], [D2], [Data or command select.],
  [RST], [GPIO], [D1], [Display hardware reset.],
  [BUSY], [GPIO input], [D0], [Display ready or busy feedback.],
)

#note(
  [WIRING RULE],
  [Do not connect display VCC to 5 V. Do not use MISO. Keep the display wires short. For the first bench build, target wire lengths of about 60 to 90 mm.]
)

#v(8pt)

#spec-table(
  (0.24fr, 0.30fr, 0.46fr),
  [SOFTWARE ITEM], [FINAL PICK], [WHY],
  [IDE], [Arduino IDE 2.x], [Simpler beginner path than a custom toolchain.],
  [Board package], [Seeed nRF52 board support for XIAO nRF52840 Sense], [Official board support path for the chosen MCU board.],
  [Display library], [GxEPD2], [Common and well-documented e-paper library for SPI panels.],
  [Graphics library], [Adafruit GFX], [Used by GxEPD2 and easy to understand for simple screen layouts.],
)

1. Read digital microphone samples at a fixed sample rate. \
2. Apply A-weighting filter in firmware. \
3. Compute RMS energy for the update window. \
4. Convert the level to dBA with the stored calibration offset. \
5. Update the display only when the visible state changes or on the scheduled refresh step.

#section([06], [Display and User Interface])

#spec-table(
  (0.24fr, 0.34fr, 0.42fr),
  [ELEMENT], [RULE], [PURPOSE],
  [Main level field], [Use the largest type on the screen.], [The user must read the sound level from across the desk.],
  [State field], [Use one short word.], [The user must know the condition at once.],
  [Dose field], [Show percent of daily target.], [The user must see long-duration exposure.],
  [Peak field], [Show maximum recent value.], [The user must see transient high sound.],
  [Battery field], [Show only if firmware battery readback is implemented.], [Battery display is secondary to sound display in V1.],
)

#v(8pt)

#spec-table(
  (0.26fr, 0.24fr, 0.50fr),
  [SCREEN STATE], [TRIGGER], [MEANING],
  [NORMAL], [Below 80 dBA], [The room sound is within the normal target zone.],
  [WARNING], [80 dBA or more], [The user should manage listening time or reduce level.],
  [ALERT], [85 dBA or more], [The user should reduce level or shorten the session.],
  [HIGH], [94 dBA or more], [The user should reduce level at once.],
)

#note(
  [SIMPLICITY RULE],
  [V1 does not need menus, graphs, Bluetooth setup, or animated transitions. The screen must behave like an instrument, not like an app.]
)

#section([07], [Bench Build Recipe])

This is the compact beginner build order. Follow it exactly.

#spec-table(
  (0.12fr, 0.42fr, 0.46fr),
  [STEP], [DO THIS], [PASS RESULT],
  [1], [Connect the XIAO board to USB-C only. Confirm that the board enumerates and can run a trivial sketch.], [Board powers correctly from USB-C.],
  [2], [Connect the LiPo battery. Confirm that the charge LED changes state when USB-C is attached and removed.], [Battery charging path works.],
  [3], [Solder and wire the e-paper display. Load a full-screen black and full-screen white display test.], [Display fully refreshes and is readable.],
  [4], [Load a microphone sample test. Print or display a raw level value. Clap near the board.], [The value changes clearly with sound.],
  [5], [Combine display and microphone into one firmware build. Show current level, peak, and average.], [The screen updates and the reading looks stable.],
  [6], [Use a reference meter and store one calibration offset.], [The displayed level now tracks the reference well enough for personal use.],
)

#note(
  [NO CASE YET],
  [Do not start CAD or 3D printing until Step 6 passes. A failed bench prototype in a beautiful case is still a failed prototype.]
)

#note(
  [DEFAULT FIRMWARE VALUES],
  [Use these first: warning at 80 dBA, alert at 85 dBA, high state at 94 dBA, display update each second, one-minute rolling average, one-point calibration offset.]
)

#section([08], [Calibration and Accuracy])

A digital microphone does not give true dBA by itself. The device needs calibration against a known reference. V1 should use a steady test sound and a reference meter at the same physical position.

The fixed calibration reference for this build is the Triplett SLM400 Sound Level Meter. It supports A weighting and fast or slow response, and it is sold as a Type 2 meter. Use A weighting and slow response during the one-point offset calibration.

1. Put the reference meter and the device at the same point. \
2. Use steady pink noise or another stable test sound. \
3. Wait for both readings to stabilize. \
4. Read the two values. \
5. Store the difference as the calibration offset. \
6. Repeat the test after a major hardware change.

#note(
  [ACCURACY RULE],
  [Do not claim legal meter accuracy. After calibration, use the value as a personal hearing-safety guide.]
)

#section([09], [Enclosure Design Recipe])

The enclosure comes after the electronics pass the bench tests. The first enclosure should be easy to print and easy to reopen.

#spec-table(
  (0.24fr, 0.26fr, 0.50fr),
  [FEATURE], [FINAL DECISION], [WHY],
  [Case style], [Two-part wedge case], [Simple to print and simple to service.],
  [Front window], [51 by 26 mm cutout], [Large enough for the visible e-paper area with a small bezel.],
  [Board mount], [Thin foam tape for V1], [Fast and forgiving for the first prototype.],
  [Battery mount], [Thin foam tape in a rear battery bay], [No custom battery holder is needed in V1.],
  [USB-C opening], [Side cutout for the XIAO connector], [Easy charging without opening the case.],
  [Microphone port], [One small hole aligned with the XIAO microphone area], [Lets room sound reach the onboard microphone.],
)

#v(8pt)

#spec-table(
  (0.22fr, 0.24fr, 0.54fr),
  [RECOMMENDED DIMENSION], [VALUE], [USE],
  [Internal width], [about 78 mm], [Fits the display board width plus wire bend room.],
  [Internal height], [about 52 mm], [Fits the display board and battery stack.],
  [Internal depth], [about 14 mm], [Fits the battery, XIAO board, and wire slack.],
  [Front angle], [about 15 to 20 degrees], [Makes the screen easy to read on a desk.],
)

#note(
  [ENCLOSURE PHILOSOPHY],
  [The first case should optimize serviceability, not elegance. Make it easy to open, easy to rewire, and easy to print again.]
)

#v(8pt)

#spec-table(
  (0.22fr, 0.22fr, 0.56fr),
  [ENCLOSURE DETAIL], [FINAL DECISION], [COMMENT],
  [Front bezel], [About 1.2 mm visible lip around the window], [Hides the board edge and keeps the screen opening clean.],
  [Rear closure], [Four printed screw bosses], [Lets you reopen the case without destroying it.],
  [USB-C cutout], [Open-sided slot], [Makes cable alignment easier for a first print.],
  [Mic opening], [Single 1.5 to 2.0 mm hole], [Small enough to stay clean, large enough for room sound.],
)

#section([10], [Final Assembly])

1. Print the case only after the bench build passes. \
2. Fit the display board into the front half and confirm the viewing window alignment. \
3. Route the eight display wires so they do not press on the screen surface. \
4. Fix the XIAO board and battery into the rear half. \
5. Check that the USB-C connector aligns with the side opening. \
6. Close the case and power the device again. \
7. Repeat the display test and microphone test. \
8. Repeat the calibration after final assembly.

#section([11], [Verification and Acceptance])

#spec-table(
  (0.16fr, 0.28fr, 0.56fr),
  [TEST ID], [TEST], [EXPECTED RESULT],
  [T-01], [USB-C charge test], [Battery charges and the device stays stable.],
  [T-02], [Battery-only run test], [Device runs with no USB cable attached.],
  [T-03], [Display test], [Full black, full white, and text screens all refresh correctly.],
  [T-04], [Microphone response test], [Reading changes clearly with controlled sound changes.],
  [T-05], [Threshold test], [State changes at the configured thresholds.],
  [T-06], [Calibration retention test], [Offset remains after power cycle.],
)

#note(
  [DONE MEANS THIS],
  [The V1 build is done only when the device works on battery, shows readable values, agrees with the reference after calibration, and still works after it is put in the case.]
)

#section([A], [Appendix A Shopping List])

#spec-table(
  (0.08fr, 0.28fr, 0.10fr, 0.54fr),
  [LINE], [ITEM], [QTY], [BUY THIS],
  [1], [Seeed Studio XIAO nRF52840 Sense], [1], [Official Seeed product page for XIAO BLE Sense nRF52840.],
  [2], [Waveshare 2.13 inch e-Paper HAT, black and white], [1], [Official Waveshare 2.13 inch e-Paper HAT, 250 by 122, SPI.],
  [3], [Adafruit 3.7 V 2000 mAh Li-ion polymer battery], [1], [Adafruit product 2011, JST-PH, 60 by 36 by 7 mm.],
  [4], [28 AWG stranded hookup wire], [1 pack], [Use for the eight display wires.],
  [5], [Lead-free rosin-core solder], [1 spool], [Use standard electronic solder only.],
  [6], [USB-C cable], [1], [For power, programming, and charge.],
  [7], [Reference sound meter], [1], [Triplett SLM400 Sound Level Meter. Use this exact meter for V1 calibration work.],
)
