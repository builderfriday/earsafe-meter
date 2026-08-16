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
    02 System Summary \
    03 Functional Requirements \
    04 Hardware Configuration \
    05 Signal and Control Architecture \
    06 Display and User Interface
  ],
  [
    07 Power System \
    08 Calibration and Accuracy \
    09 Mechanical Arrangement \
    10 Prototype Build Sequence \
    11 Verification Tests \
    Appendix A Preliminary Bill of Materials
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

#section([02], [System Summary])

#spec-table(
  (0.22fr, 0.28fr, 0.50fr),
  [ITEM], [TARGET], [ENGINEERING REASON],
  [Form], [Self-standing desk unit], [The device must sit at the listener area without extra support.],
  [Display], [2.13 inch black-and-white e-ink], [The display must stay readable and low power.],
  [Controller], [nRF52840 class module], [The controller must support low-power sampling and simple peripheral control.],
  [Microphone], [Digital MEMS microphone], [The signal path must stay stable and simple.],
  [Battery], [3000 mAh LiPo nominal], [The device must give practical battery life.],
  [Core outputs], [Current dBA, 1 min average, peak, daily dose], [The user must see present state and exposure history.],
)

#v(10pt)
- Keep the first build simple.
- Use standard modules before a custom board.
- Do not depend on Wi-Fi in the default mode.
- Make one value lead the screen.

#section([03], [Functional Requirements])

#spec-table(
  (0.14fr, 0.58fr, 0.28fr),
  [ID], [REQUIREMENT], [PASS CONDITION],
  [REQ-01], [The device must show present A-weighted sound level in dBA.], [User can read the value on the main screen.],
  [REQ-02], [The device must show warning state at 80 dBA and alert state at 85 dBA.], [State changes at the set thresholds.],
  [REQ-03], [The device must track cumulative daily sound dose with a 3 dB exchange rule.], [Dose value rises during a controlled sound test.],
  [REQ-04], [The device must operate from internal battery power.], [Device runs with no USB cable attached.],
  [REQ-05], [The device must store calibration offset in non-volatile memory.], [Offset remains after power cycle.],
  [REQ-06], [The device must show low-battery state before shutdown.], [User sees warning before the battery is depleted.],
)

#section([04], [Hardware Configuration])

V1 should use a development-board architecture. This rule reduces risk. This rule also reduces build time.

#spec-table(
  (0.26fr, 0.34fr, 0.40fr),
  [UNIT], [PREFERRED CLASS], [NOTES],
  [Main board], [XIAO nRF52840 Sense or equivalent], [Pick a board with battery support if available.],
  [Microphone], [On-board digital mic or external I2S or PDM MEMS mic], [External mic gives better placement freedom.],
  [Display], [2.13 inch e-ink module], [Do not use a tri-color display in V1.],
  [Battery], [Protected 1-cell LiPo], [Use a protected cell only.],
  [Charge path], [USB-C 5 V input], [Do not require USB Power Delivery for V1.],
  [User input], [One or two push buttons], [Keep the interface simple.],
  [Optional alert], [Low-current LED or piezo buzzer], [The alert may be omitted in the first quiet prototype.],
)

#section([05], [Signal and Control Architecture])

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
1. Read digital microphone samples at a fixed sample rate. \
2. Remove DC bias if the selected microphone path requires it. \
3. Apply A-weighting filter in firmware. \
4. Compute RMS energy for the update window. \
5. Convert the level to dBA with the stored calibration offset. \
6. Update the display only when the visible state changes or on the scheduled refresh step.

#section([06], [Display and User Interface])

#spec-table(
  (0.24fr, 0.34fr, 0.42fr),
  [ELEMENT], [RULE], [PURPOSE],
  [Main level field], [Use the largest type on the screen.], [The user must read the sound level from across the desk.],
  [State field], [Use one short word.], [The user must know the condition at once.],
  [Dose field], [Show percent of daily target.], [The user must see long-duration exposure.],
  [Peak field], [Show maximum recent value.], [The user must see transient high sound.],
  [Battery field], [Show icon or percent.], [The user must not lose power without warning.],
)

#section([07], [Power System])

The default operating mode is battery power. USB-C is for charge and optional desk power. The firmware must reduce needless display refresh. Wireless functions must stay off unless the user needs them.

#spec-table(
  (0.28fr, 0.24fr, 0.48fr),
  [PARAMETER], [TARGET], [COMMENT],
  [Nominal battery], [3000 mAh], [This value is a starting point. Test may change it.],
  [Charge input], [USB-C 5 V], [Keep the charge path simple.],
  [Low-battery warning], [20 percent target], [The exact value may change after battery test.],
  [Primary alert method], [Display state change], [This method uses less power than continuous active output.],
)

#section([08], [Calibration and Accuracy])

A digital microphone does not give true dBA by itself. The device needs calibration against a known reference. V1 should use a steady test sound and a reference meter at the same physical position.

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

#section([09], [Mechanical Arrangement])

The case should be a compact wedge or upright desk form. The front face should point to the user. The microphone port must have a direct acoustic path to room sound.

#spec-table(
  (0.26fr, 0.30fr, 0.44fr),
  [FEATURE], [REQUIREMENT], [DESIGN RULE],
  [Case form], [Self-standing body], [Do not require a separate stand.],
  [Display angle], [Readable at normal desk view], [Bias the face to seated eye height.],
  [Microphone opening], [Direct acoustic port], [Do not block the port with dense structure.],
  [USB-C access], [Rear or side entry], [Do not force a sharp cable bend.],
  [Battery bay], [Protected internal space], [Keep the cell away from sharp edges and screws.],
)

#section([10], [Prototype Build Sequence])

1. Make the electronics work on the bench. \
2. Show a basic e-ink screen. \
3. Read live sound data from the microphone. \
4. Compute present dBA and daily dose. \
5. Set threshold logic and state labels. \
6. Calibrate the device with a reference meter. \
7. Move the system into the printed case. \
8. Repeat the calibration and battery tests after final assembly.

#section([11], [Verification Tests])

#spec-table(
  (0.16fr, 0.28fr, 0.56fr),
  [TEST ID], [TEST], [EXPECTED RESULT],
  [T-01], [USB-C charge test], [Battery charges and the device stays stable.],
  [T-02], [Battery-only run test], [Device runs with no USB cable attached.],
  [T-03], [Sound response test], [Level value changes with controlled source level change.],
  [T-04], [Threshold test], [State changes at the configured thresholds.],
  [T-05], [Dose accumulation test], [Dose rises with controlled exposure duration.],
  [T-06], [Calibration retention test], [Offset remains after power cycle.],
)

#section([A], [Appendix A Preliminary Bill of Materials])

#spec-table(
  (0.10fr, 0.30fr, 0.10fr, 0.50fr),
  [LINE], [ITEM], [QTY], [NOTES],
  [1], [Main controller board], [1], [nRF52840 class board with digital microphone support.],
  [2], [E-ink display module], [1], [2.13 inch black-and-white module.],
  [3], [Protected LiPo cell], [1], [3000 mAh nominal starting target.],
  [4], [Push button], [1-2], [For screen change and calibration mode.],
  [5], [USB-C charge path], [1], [For charging and optional desk power.],
  [6], [Printed enclosure], [1], [Two-part shell with microphone port and display window.],
  [7], [Optional LED or buzzer], [0-1], [Use only if the warning mode needs it.],
)
