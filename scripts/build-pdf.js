const fs = require("fs");
const path = require("path");
const PDFDocument = require("pdfkit");

const outputPath = path.join(__dirname, "..", "docs", "specification.pdf");

const doc = new PDFDocument({
  size: "LETTER",
  margins: { top: 56, bottom: 56, left: 60, right: 60 },
  info: {
    Title: "EARSAFE METER V1 Technical Specification",
    Author: "builderfriday",
    Subject: "Battery-powered desk sound monitor specification",
    Keywords: "sound meter, hearing safety, e-ink, technical manual",
  },
});

doc.pipe(fs.createWriteStream(outputPath));

const page = {
  width: 612,
  height: 792,
  left: 60,
  right: 552,
  top: 56,
  bottom: 736,
  contentWidth: 492,
};

const palette = {
  ink: "#101214",
  accent: "#7a2414",
  muted: "#5e6368",
  rule: "#222222",
  lightRule: "#b7b1a7",
};

let pageNumber = 1;
let headerLabel = "";
let y = page.top;

function setInk() {
  doc.fillColor(palette.ink).strokeColor(palette.rule);
}

function addBodyPage(label) {
  doc.addPage();
  pageNumber += 1;
  headerLabel = label;
  drawBodyChrome();
  y = 96;
}

function drawBodyChrome() {
  setInk();
  doc.lineWidth(0.8).moveTo(page.left, 48).lineTo(page.right, 48).stroke();
  doc
    .font("Helvetica")
    .fontSize(8)
    .fillColor(palette.ink)
    .text("EARSAFE METER V1", page.left, 34, { width: 180 });
  doc
    .font("Helvetica")
    .fontSize(8)
    .fillColor(palette.ink)
    .text(headerLabel.toUpperCase(), page.left + 180, 34, {
      width: page.contentWidth - 180,
      align: "right",
    });
  doc.lineWidth(0.8).moveTo(page.left, 744).lineTo(page.right, 744).stroke();
  doc
    .font("Helvetica")
    .fontSize(8)
    .fillColor(palette.muted)
    .text("DOCUMENT EM-V1", page.left, 752, { width: 120 });
  doc
    .font("Helvetica")
    .fontSize(8)
    .fillColor(palette.muted)
    .text("REV A", page.left + 180, 752, { width: 80, align: "center" });
  doc
    .font("Helvetica")
    .fontSize(8)
    .fillColor(palette.muted)
    .text(String(pageNumber), page.right - 40, 752, { width: 40, align: "right" });
  setInk();
}

function ensureSpace(height, nextHeader = headerLabel) {
  if (y + height > 724) {
    addBodyPage(nextHeader);
  }
}

function rule(offset = 0) {
  const lineY = y + offset;
  doc.lineWidth(0.8).moveTo(page.left, lineY).lineTo(page.right, lineY).stroke();
}

function sectionStart(number, title) {
  const needed = 48;
  ensureSpace(needed, title);
  headerLabel = title;
  doc
    .font("Helvetica-Bold")
    .fontSize(9)
    .fillColor(palette.accent)
    .text(`SECTION ${String(number).padStart(2, "0")}`, page.left, y, { width: 90 });
  doc
    .font("Helvetica-Bold")
    .fontSize(18)
    .fillColor(palette.ink)
    .text(title, page.left + 96, y - 4, { width: page.contentWidth - 96 });
  y += 24;
  doc.lineWidth(0.8).moveTo(page.left, y).lineTo(page.right, y).stroke();
  y += 16;
  setInk();
}

function paragraph(text, options = {}) {
  const width = options.width || page.contentWidth;
  const x = options.x || page.left;
  const font = options.font || "Helvetica";
  const size = options.size || 10;
  const leading = options.leading || 4;
  doc.font(font).fontSize(size);
  const height = doc.heightOfString(text, { width, align: options.align || "left", lineGap: leading });
  ensureSpace(height + (options.after || 8), headerLabel);
  doc
    .font(font)
    .fontSize(size)
    .fillColor(options.color || palette.ink)
    .text(text, x, y, { width, align: options.align || "left", lineGap: leading });
  y += height + (options.after || 8);
  setInk();
}

function noteBox(label, text) {
  doc.font("Helvetica-Bold").fontSize(9);
  const labelHeight = doc.heightOfString(label, { width: 90 });
  doc.font("Helvetica").fontSize(10);
  const textHeight = doc.heightOfString(text, { width: page.contentWidth - 24, lineGap: 4 });
  const boxHeight = 18 + labelHeight + textHeight + 10;
  ensureSpace(boxHeight + 10, headerLabel);
  doc.rect(page.left, y, page.contentWidth, boxHeight).lineWidth(0.8).stroke();
  doc
    .font("Helvetica-Bold")
    .fontSize(9)
    .fillColor(palette.accent)
    .text(label, page.left + 10, y + 9, { width: 120 });
  doc
    .font("Helvetica")
    .fontSize(10)
    .fillColor(palette.ink)
    .text(text, page.left + 10, y + 23, { width: page.contentWidth - 20, lineGap: 4 });
  y += boxHeight + 12;
  setInk();
}

function bulletList(items, options = {}) {
  const width = options.width || page.contentWidth - 18;
  const x = options.x || page.left + 18;
  const size = options.size || 10;
  const gap = options.gap || 6;
  for (const item of items) {
    doc.font("Helvetica").fontSize(size);
    const height = doc.heightOfString(item, { width, lineGap: 3 });
    ensureSpace(height + gap, headerLabel);
    doc.circle(x - 10, y + 6, 1.4).fill(palette.ink);
    doc
      .font("Helvetica")
      .fontSize(size)
      .fillColor(palette.ink)
      .text(item, x, y, { width, lineGap: 3 });
    y += height + gap;
    setInk();
  }
  y += 2;
}

function numberedList(items) {
  items.forEach((item, index) => {
    const label = `${index + 1}.`;
    doc.font("Helvetica-Bold").fontSize(10);
    const height = Math.max(
      doc.heightOfString(label, { width: 18 }),
      doc.heightOfString(item, { width: page.contentWidth - 28, lineGap: 3 })
    );
    ensureSpace(height + 5, headerLabel);
    doc
      .font("Helvetica-Bold")
      .fontSize(10)
      .fillColor(palette.ink)
      .text(label, page.left, y, { width: 18 });
    doc
      .font("Helvetica")
      .fontSize(10)
      .fillColor(palette.ink)
      .text(item, page.left + 24, y, { width: page.contentWidth - 24, lineGap: 3 });
    y += height + 5;
    setInk();
  });
  y += 3;
}

function drawTable(columns, rows, options = {}) {
  const startX = options.x || page.left;
  const tableWidth = options.width || page.contentWidth;
  const widths = columns.map((col) => tableWidth * col.width);
  const headerSize = options.headerSize || 8.5;
  const bodySize = options.bodySize || 9.5;
  const paddingX = 6;
  const paddingY = 5;

  const measureRow = (cells, fontSize, header = false) => {
    let maxHeight = 0;
    cells.forEach((cell, index) => {
      doc.font(header ? "Helvetica-Bold" : "Helvetica").fontSize(fontSize);
      const cellHeight = doc.heightOfString(String(cell), {
        width: widths[index] - paddingX * 2,
        lineGap: 2,
      });
      maxHeight = Math.max(maxHeight, cellHeight);
    });
    return maxHeight + paddingY * 2;
  };

  const headerHeight = measureRow(columns.map((c) => c.label), headerSize, true);
  const rowHeights = rows.map((row) => measureRow(row, bodySize, false));
  const totalHeight = headerHeight + rowHeights.reduce((sum, value) => sum + value, 0) + 2;
  ensureSpace(totalHeight + 10, headerLabel);

  doc.lineWidth(0.8).moveTo(startX, y).lineTo(startX + tableWidth, y).stroke();
  let cursorX = startX;
  columns.forEach((column, index) => {
    doc
      .font("Helvetica-Bold")
      .fontSize(headerSize)
      .fillColor(palette.accent)
      .text(column.label, cursorX + paddingX, y + paddingY, {
        width: widths[index] - paddingX * 2,
      });
    cursorX += widths[index];
  });
  y += headerHeight;
  doc.lineWidth(0.8).moveTo(startX, y).lineTo(startX + tableWidth, y).stroke();

  rows.forEach((row, rowIndex) => {
    const rowHeight = rowHeights[rowIndex];
    let rowX = startX;
    row.forEach((cell, colIndex) => {
      doc
        .font("Helvetica")
        .fontSize(bodySize)
        .fillColor(palette.ink)
        .text(String(cell), rowX + paddingX, y + paddingY, {
          width: widths[colIndex] - paddingX * 2,
          lineGap: 2,
        });
      rowX += widths[colIndex];
    });
    y += rowHeight;
    doc.lineWidth(0.5).moveTo(startX, y).lineTo(startX + tableWidth, y).strokeColor(palette.lightRule).stroke();
    doc.strokeColor(palette.rule);
  });

  y += 10;
  setInk();
}

function drawContents() {
  addBodyPage("Contents");
  sectionStart(0, "Contents");
  paragraph(
    "This specification defines the first build of EARSAFE METER. The device is a battery-powered desk sound monitor. It shows present sound level, warning state, peak level, and daily sound dose."
  );

  const items = [
    "01 Purpose and Use Limits",
    "02 System Summary",
    "03 Functional Requirements",
    "04 Hardware Configuration",
    "05 Signal and Control Architecture",
    "06 Display and User Interface",
    "07 Power System",
    "08 Calibration and Accuracy",
    "09 Mechanical Arrangement",
    "10 Prototype Build Sequence",
    "11 Verification Tests",
    "Appendix A Preliminary Bill of Materials",
  ];

  const leftX = page.left;
  const rightX = page.left + 255;
  let leftY = y + 8;
  let rightY = y + 8;

  items.forEach((item, index) => {
    const x = index < 6 ? leftX : rightX;
    const targetY = index < 6 ? leftY : rightY;
    doc
      .font("Helvetica")
      .fontSize(10.5)
      .fillColor(palette.ink)
      .text(item, x, targetY, { width: 210, lineGap: 3 });
    if (index < 6) {
      leftY += 22;
    } else {
      rightY += 22;
    }
  });

  y = Math.max(leftY, rightY) + 12;
  noteBox(
    "DOCUMENT INTENT",
    "This document must stay direct. It must stay technical. It must not use decorative filler, startup language, or sales language."
  );
}

function drawCover() {
  setInk();
  doc.lineWidth(1.2).moveTo(page.left, 72).lineTo(page.right, 72).stroke();
  doc
    .font("Courier")
    .fontSize(9)
    .fillColor(palette.accent)
    .text("TECHNICAL SPECIFICATION MANUAL", page.left, 56, { width: 220 });

  doc
    .font("Helvetica-Bold")
    .fontSize(29)
    .fillColor(palette.ink)
    .text("EARSAFE METER V1", page.left, 118, { width: 300 });
  doc
    .font("Helvetica")
    .fontSize(12)
    .fillColor(palette.muted)
    .text(
      "Battery-powered desk sound monitor for personal sound exposure control.",
      page.left,
      156,
      { width: 320, lineGap: 3 }
    );

  const blockX = 372;
  const blockY = 116;
  const blockW = 180;
  const blockH = 152;
  doc.rect(blockX, blockY, blockW, blockH).lineWidth(0.8).stroke();
  const rows = [
    ["DOCUMENT", "EM-V1"],
    ["REVISION", "A"],
    ["STATUS", "INITIAL ISSUE"],
    ["OWNER", "BUILDERFRIDAY"],
    ["FORMAT", "PDF"],
    ["EXPORT", "VECTOR TYPESET"],
  ];
  rows.forEach((row, index) => {
    const rowY = blockY + index * 25.3;
    if (index > 0) {
      doc.lineWidth(0.5).moveTo(blockX, rowY).lineTo(blockX + blockW, rowY).strokeColor(palette.lightRule).stroke();
      doc.strokeColor(palette.rule);
    }
    doc
      .font("Courier")
      .fontSize(8.5)
      .fillColor(palette.accent)
      .text(row[0], blockX + 8, rowY + 8, { width: 72 });
    doc
      .font("Helvetica")
      .fontSize(9.5)
      .fillColor(palette.ink)
      .text(row[1], blockX + 88, rowY + 7, { width: 80 });
  });

  doc.lineWidth(0.8).moveTo(page.left, 214).lineTo(page.right, 214).stroke();
  doc
    .font("Helvetica")
    .fontSize(10)
    .fillColor(palette.ink)
    .text("Design intent", page.left, 232, { width: 80 });
  bulletList(
    [
      "Measure room sound near the listener position.",
      "Show one clear sound level value at a glance.",
      "Show warning state before daily sound dose becomes excessive.",
      "Run from internal battery power with USB-C charge.",
    ],
    { x: page.left + 18, width: 282, size: 10 }
  );

  const sketchX = 300;
  const sketchY = 326;
  doc.save();
  doc.translate(sketchX, sketchY);
  doc.lineWidth(1.0).strokeColor(palette.accent);
  doc.moveTo(0, 140).lineTo(42, 98).lineTo(180, 98).lineTo(138, 140).closePath().stroke();
  doc.rect(0, 28, 138, 112).stroke();
  doc.moveTo(138, 28).lineTo(180, 0).lineTo(180, 98).stroke();
  doc.moveTo(138, 28).lineTo(138, 140).stroke();
  doc.rect(20, 52, 74, 42).stroke();
  [108, 116, 124].forEach((cx) => doc.circle(cx, 74, 2).stroke());
  doc.moveTo(20, 104).lineTo(118, 104).stroke();
  doc.restore();

  doc
    .font("Helvetica")
    .fontSize(8.5)
    .fillColor(palette.muted)
    .text("Front and side concept view", sketchX, 478, { width: 180, align: "center" });

  doc.lineWidth(0.8).moveTo(page.left, 680).lineTo(page.right, 680).stroke();
  doc
    .font("Courier")
    .fontSize(8)
    .fillColor(palette.muted)
    .text("PERSONAL ACOUSTIC MONITOR / FIRST ENGINEERING ISSUE", page.left, 690, {
      width: page.contentWidth,
      align: "left",
    });
}

function drawArchitectureFigure() {
  ensureSpace(170, headerLabel);
  const x = page.left + 8;
  const top = y + 6;
  const boxes = [
    { x: x, y: top + 22, w: 78, h: 34, label: "MIC" },
    { x: x + 112, y: top + 22, w: 102, h: 34, label: "MCU INPUT" },
    { x: x + 250, y: top + 22, w: 126, h: 34, label: "A-WEIGHT / RMS" },
    { x: x + 410, y: top + 22, w: 72, h: 34, label: "DISPLAY" },
    { x: x + 250, y: top + 104, w: 126, h: 34, label: "SETTINGS / OFFSET" },
    { x: x + 410, y: top + 104, w: 72, h: 34, label: "ALERT" },
    { x: x + 112, y: top + 104, w: 102, h: 34, label: "POWER CTRL" },
    { x: x, y: top + 104, w: 78, h: 34, label: "USB-C / CELL" },
  ];

  boxes.forEach((box) => {
    doc.rect(box.x, box.y, box.w, box.h).lineWidth(0.8).stroke();
    doc
      .font("Helvetica")
      .fontSize(8.5)
      .fillColor(palette.ink)
      .text(box.label, box.x, box.y + 11, { width: box.w, align: "center" });
  });

  const arrows = [
    [x + 78, top + 39, x + 112, top + 39],
    [x + 214, top + 39, x + 250, top + 39],
    [x + 376, top + 39, x + 410, top + 39],
    [x + 326, top + 56, x + 326, top + 104],
    [x + 78, top + 121, x + 112, top + 121],
    [x + 214, top + 121, x + 250, top + 121],
    [x + 376, top + 121, x + 410, top + 121],
  ];

  arrows.forEach(([x1, y1, x2, y2]) => {
    doc.moveTo(x1, y1).lineTo(x2, y2).stroke();
    if (x2 !== x1) {
      const dir = x2 > x1 ? 1 : -1;
      doc
        .moveTo(x2 - 6 * dir, y2 - 3)
        .lineTo(x2, y2)
        .lineTo(x2 - 6 * dir, y2 + 3)
        .stroke();
    } else {
      const dir = y2 > y1 ? 1 : -1;
      doc
        .moveTo(x2 - 3, y2 - 6 * dir)
        .lineTo(x2, y2)
        .lineTo(x2 + 3, y2 - 6 * dir)
        .stroke();
    }
  });

  y = top + 152;
  paragraph("Figure 1. The signal enters through the microphone. The MCU computes the sound level. The logic updates the display, alert state, and stored calibration data.", {
    size: 8.8,
    color: palette.muted,
    after: 4,
  });
}

drawCover();
drawContents();

sectionStart(1, "Purpose and Use Limits");
paragraph(
  "EARSAFE METER V1 is a desk sound monitor. The device measures sound near the user position. The device shows the present A-weighted sound level. The device also shows warning state, peak level, and daily sound dose."
);
paragraph(
  "Use the device for personal sound control during music use, speaker testing, long study sessions, and other repeated listening activity. Do not use the device as a certified legal meter. Do not use the device as the only control for industrial safety."
);
noteBox(
  "USE LIMIT",
  "The reading becomes useful only after calibration against a known reference meter. Before calibration, use the value as relative guidance."
);

sectionStart(2, "System Summary");
drawTable(
  [
    { label: "ITEM", width: 0.24 },
    { label: "TARGET", width: 0.32 },
    { label: "ENGINEERING REASON", width: 0.44 },
  ],
  [
    ["Form", "Self-standing desk unit", "The device must sit at the listener area without extra support."],
    ["Display", "2.13 inch black-and-white e-ink", "The display must stay readable and low power."],
    ["Controller", "nRF52840 class module", "The controller must support low-power sampling and simple peripheral control."],
    ["Microphone", "Digital MEMS microphone", "The signal path must stay stable and simple."],
    ["Battery", "3000 mAh LiPo nominal", "The device must give practical battery life."],
    ["Core outputs", "Current dBA, 1 min average, peak, daily dose", "The user must see present state and exposure history."],
  ]
);
bulletList([
  "Keep the first build simple.",
  "Use standard modules before a custom board.",
  "Do not depend on Wi-Fi in the default mode.",
  "Make one value lead the screen.",
]);

sectionStart(3, "Functional Requirements");
drawTable(
  [
    { label: "ID", width: 0.13 },
    { label: "REQUIREMENT", width: 0.61 },
    { label: "PASS CONDITION", width: 0.26 },
  ],
  [
    ["REQ-01", "The device must show present A-weighted sound level in dBA.", "User can read the value on the main screen."],
    ["REQ-02", "The device must show warning state at 80 dBA and alert state at 85 dBA.", "State changes at the set thresholds."],
    ["REQ-03", "The device must track cumulative daily sound dose with a 3 dB exchange rule.", "Dose value rises during a controlled sound test."],
    ["REQ-04", "The device must operate from internal battery power.", "Device runs with no USB cable attached."],
    ["REQ-05", "The device must store calibration offset in non-volatile memory.", "Offset remains after power cycle."],
    ["REQ-06", "The device must show low-battery state before shutdown.", "User sees warning before the battery is depleted."],
  ]
);

sectionStart(4, "Hardware Configuration");
paragraph("V1 should use a development-board architecture. This rule reduces risk. This rule also reduces build time.");
drawTable(
  [
    { label: "UNIT", width: 0.28 },
    { label: "PREFERRED CLASS", width: 0.35 },
    { label: "NOTES", width: 0.37 },
  ],
  [
    ["Main board", "XIAO nRF52840 Sense or equivalent", "Pick a board with battery support if available."],
    ["Microphone", "On-board digital mic or external I2S/PDM MEMS mic", "External mic gives better placement freedom."],
    ["Display", "2.13 inch e-ink module", "Do not use a tri-color display in V1."],
    ["Battery", "Protected 1-cell LiPo", "Use a protected cell only."],
    ["Charge path", "USB-C 5 V input", "Do not require USB PD for V1."],
    ["User input", "One or two push buttons", "Keep the interface simple."],
    ["Optional alert", "Low-current LED or piezo buzzer", "The alert may be omitted in the first quiet prototype."],
  ]
);

sectionStart(5, "Signal and Control Architecture");
paragraph(
  "The sound enters through the digital microphone. The controller reads the signal. The firmware applies A-weighting and RMS logic. The firmware then computes present dBA, 1 minute average, peak, and daily dose."
);
drawArchitectureFigure();
numberedList([
  "Read digital microphone samples at a fixed sample rate.",
  "Remove DC bias if the selected microphone path requires it.",
  "Apply A-weighting filter in firmware.",
  "Compute RMS energy for the update window.",
  "Convert the level to dBA with the stored calibration offset.",
  "Update the display only when the visible state changes or on the scheduled refresh step.",
]);

sectionStart(6, "Display and User Interface");
drawTable(
  [
    { label: "ELEMENT", width: 0.24 },
    { label: "RULE", width: 0.38 },
    { label: "PURPOSE", width: 0.38 },
  ],
  [
    ["Main level field", "Use the largest type on the screen.", "The user must read the sound level from across the desk."],
    ["State field", "Use one short word.", "The user must know the condition at once."],
    ["Dose field", "Show percent of daily target.", "The user must see long-duration exposure."],
    ["Peak field", "Show maximum recent value.", "The user must see transient high sound."],
    ["Battery field", "Show icon or percent.", "The user must not lose power without warning."],
  ]
);
drawTable(
  [
    { label: "STATE", width: 0.2 },
    { label: "ENTRY CONDITION", width: 0.38 },
    { label: "USER MEANING", width: 0.42 },
  ],
  [
    ["NORMAL", "Below warning threshold", "The sound level is acceptable for present use."],
    ["WARNING", "At or above 80 dBA", "The user should manage time or reduce level."],
    ["ALERT", "At or above 85 dBA", "Exposure control is now important."],
    ["HIGH ALERT", "At or above 94 dBA", "The user should reduce sound level at once."],
    ["LOW BATTERY", "Battery under low limit", "The device needs charge soon."],
  ]
);

sectionStart(7, "Power System");
paragraph(
  "The default operating mode is battery power. USB-C is for charge and optional desk power. The firmware must reduce needless display refresh. Wireless functions must stay off unless the user needs them."
);
drawTable(
  [
    { label: "PARAMETER", width: 0.28 },
    { label: "TARGET", width: 0.26 },
    { label: "COMMENT", width: 0.46 },
  ],
  [
    ["Nominal battery", "3000 mAh", "This value is a starting point. Test may change it."],
    ["Charge input", "USB-C 5 V", "Keep the charge path simple."],
    ["Low-battery warning", "20 percent target", "The exact value may change after battery test."],
    ["Primary alert method", "Display state change", "This method uses less power than continuous active output."],
  ]
);

sectionStart(8, "Calibration and Accuracy");
paragraph(
  "A digital microphone does not give true dBA by itself. The device needs calibration against a known reference. V1 should use a steady test sound and a reference meter at the same physical position."
);
numberedList([
  "Put the reference meter and the device at the same point.",
  "Use steady pink noise or another stable test sound.",
  "Wait for both readings to stabilize.",
  "Read the two values.",
  "Store the difference as the calibration offset.",
  "Repeat the test after a major hardware change.",
]);
noteBox(
  "ACCURACY RULE",
  "Do not claim legal meter accuracy. After calibration, use the value as a personal hearing-safety guide."
);

sectionStart(9, "Mechanical Arrangement");
paragraph(
  "The case should be a compact wedge or upright desk form. The front face should point to the user. The microphone port must have a direct acoustic path to room sound."
);
drawTable(
  [
    { label: "FEATURE", width: 0.28 },
    { label: "REQUIREMENT", width: 0.32 },
    { label: "DESIGN RULE", width: 0.4 },
  ],
  [
    ["Case form", "Self-standing body", "Do not require a separate stand."],
    ["Display angle", "Readable at normal desk view", "Bias the face to seated eye height."],
    ["Microphone opening", "Direct acoustic port", "Do not block the port with dense structure."],
    ["USB-C access", "Rear or side entry", "Do not force a sharp cable bend."],
    ["Battery bay", "Protected internal space", "Keep the cell away from sharp edges and screws."],
  ]
);

sectionStart(10, "Prototype Build Sequence");
numberedList([
  "Make the electronics work on the bench.",
  "Show a basic e-ink screen.",
  "Read live sound data from the microphone.",
  "Compute present dBA and daily dose.",
  "Set threshold logic and state labels.",
  "Calibrate the device with a reference meter.",
  "Move the system into the printed case.",
  "Repeat the calibration and battery tests after final assembly.",
]);

sectionStart(11, "Verification Tests");
drawTable(
  [
    { label: "TEST ID", width: 0.16 },
    { label: "TEST", width: 0.3 },
    { label: "EXPECTED RESULT", width: 0.54 },
  ],
  [
    ["T-01", "USB-C charge test", "Battery charges and the device stays stable."],
    ["T-02", "Battery-only run test", "Device runs with no USB cable attached."],
    ["T-03", "Sound response test", "Level value changes with controlled source level change."],
    ["T-04", "Threshold test", "State changes at the configured thresholds."],
    ["T-05", "Dose accumulation test", "Dose rises with controlled exposure duration."],
    ["T-06", "Calibration retention test", "Offset remains after power cycle."],
  ]
);

sectionStart("A", "Appendix A Preliminary Bill of Materials");
drawTable(
  [
    { label: "LINE", width: 0.1 },
    { label: "ITEM", width: 0.32 },
    { label: "QTY", width: 0.1 },
    { label: "NOTES", width: 0.48 },
  ],
  [
    ["1", "Main controller board", "1", "nRF52840 class board with digital microphone support."],
    ["2", "E-ink display module", "1", "2.13 inch black-and-white module."],
    ["3", "Protected LiPo cell", "1", "3000 mAh nominal starting target."],
    ["4", "Push button", "1-2", "For screen change and calibration mode."],
    ["5", "USB-C cable or receptacle path", "1", "For charging and optional desk power."],
    ["6", "Printed enclosure", "1", "Two-part shell with microphone port and display window."],
    ["7", "Optional LED or buzzer", "0-1", "Use only if the warning mode needs it."],
  ]
);

doc.end();
