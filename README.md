# OpenSCAD designs

A collection of parametric models, practical replacement parts, robotics components,
3D printing tools, and modeling experiments by Andrew C Mattson.

The original `.scad` files are the primary source. Most designs live in the root
directory; eligible OpenSCAD autosaves live in `backups/`. Some files are experiments
or works in progress, so review the model and its dimensions before printing.

## Examples

- Robotics: [pebble-chassis.scad](pebble-chassis.scad),
  [robot-cam-car-chassis.scad](robot-cam-car-chassis.scad), and
  [fred-tracks.scad](fred-tracks.scad).
- Printing and plotting: [pen-plotter-tool.scad](pen-plotter-tool.scad),
  [ender-utensil-holder.scad](ender-utensil-holder.scad), and
  [printer_cutter_attachment.scad](printer_cutter_attachment.scad).
- Household parts: [bath_drain_plug.scad](bath_drain_plug.scad),
  [better-command-strip-hook.scad](better-command-strip-hook.scad), and
  [window-clamp.scad](window-clamp.scad).
- Mechanisms: [cycloidal.scad](cycloidal.scad),
  [roller_bearing_v2.scad](roller_bearing_v2.scad), and
  [toy_bolt.scad](toy_bolt.scad).

## Using a design

Open a `.scad` file in OpenSCAD, adjust its parameters, preview with **F5**,
and render with **F6** before exporting a mesh for your slicer.
Keep the repository's folder layout so relative imports and libraries resolve.

To export from the command line, for example:

```sh
openscad -o bath_drain_plug.stl bath_drain_plug.scad
```

Fonts used by text-based models need to be installed on your system. Personal
meeting information, apartment identifiers, and private names in examples have
been replaced with editable placeholder text.

## What is tracked

The ignore rules retain `.scad` sources and local files they reference, including
input STL meshes and SVG outlines. Other files, such as generated meshes, slicer
projects, G-code, and unrelated Python scripts, are ignored. Documentation,
`.gitignore`, and the small dependency scanner are also tracked.

Sources with missing or external dependencies are excluded, along with any sources
that depend on them. The initial exclusions are:

- `fillets3d.scad`: missing `fillets2d.scad`.
- `backups/phone-case-backup-nrbvWoVp.scad`: missing `s20plus.stl`.
- `backups/Pawprint-backup-CUjNTSRc.scad`: missing `cutout pawprint white.png`.
- `Pawprint.scad`: empty surface input filename.

These files remain on the original machine. They can become eligible if their
dependencies are supplied locally and the ignore rules are regenerated.

Git's ignore patterns cannot inspect file contents. After adding or changing source
dependencies, regenerate the explicit exceptions before staging:

```sh
python3 tools/sync-ignore
git add .
git commit -m "Update designs"
```

Use `python3 tools/sync-ignore --check` to verify that the rules are current.
The scanner recognizes literal input filenames and `include`/`use` directives,
ignores comments, and excludes unresolved variable or computed input paths.
If a previously tracked file becomes ineligible, also remove it from Git's index
with `git rm --cached -- path/to/file`; this keeps the local file.

## Attribution

Some bundled sources contain third-party attribution and licensing notices.
Preserve those notices and review the relevant file before redistribution.
This repository does not assign a new blanket license to those sources.
