# EARSAFE METER

EARSAFE METER is a battery-powered desk sound monitor. It measures room sound level, shows a clear warning on an e-ink display, and tracks daily sound dose. The device is for personal sound control during speaker use, music work, study, and long listening sessions.

This repository is the specification package for `V1`.

Contents:

- `docs/specification.pdf` — exported PDF manual
- `scripts/build-pdf.js` — direct vector PDF generator
- `scripts/build-pdf.sh` — repeatable build entrypoint
- `package.json` — local build dependency definition

Design intent:

- Simple desk device
- Battery power with USB-C charge
- Low-power display
- Clear sound warning at a glance
- Easy first build with standard modules
- Clean document output with no browser-print layout

Important:

This device is not a certified legal sound meter. It becomes a useful hearing-safety guide only after calibration against a known reference meter.
