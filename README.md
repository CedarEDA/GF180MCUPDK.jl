## Sky130 PDK for Cedar

<a href="https://help.juliahub.com/gf180mcu/dev/"><img src='https://img.shields.io/badge/docs-dev-blue.svg'/></a>

This package redistributes the Skywater 130nm PDK (as distributed by https://github.com/RTimothyEdwards/open_pdks) for use with Cedar.

## Usage

When CedarSim reads the netlist and sees a file path for an `.include` or `.lib` file
with a `jlpkg://GF180MCUPDK` prefix it will reference the `GF180MCUPDK` model files via
the Julia package mechanism.  Modify your netlist like so:

```
.include "jlpkg://GF180MCUPDK/model/design.ngspice"
.LIB "jlpkg://GF180MCUPDK/model/sm141064.ngspice" typical
```
