# GF180MCUPDK.jl

The purpose of this package is to make it extremely easy to include the GF180MCUPDK by use of the 
Julia package manager which allows for simple installation, compatible version resolution and updating.

## PDK Contents
This GF180MCUPDK originally came from the Google/Global Foundries collaboration [here](https://github.com/google/gf180mcu-pdk).
If there are issues then please [open an Issue](https://github.com/CedarEDA/GF180MCUPDK.jl/issues).

## Usage
### 1. Netlist Usage

When CedarSim reads the netlist and sees a file path for an `.include` or `.lib` file 
with a `jlpkg://GF180MCUPDK` prefix it will reference the `GF180MCUPDK` model files via 
the Julia package mechanism.  Modify your netlist like so:

```
.include "jlpkg://GF180MCUPDK/model/design.ngspice"
.LIB "jlpkg://GF180MCUPDK/model/sm141064.ngspice" typical
```

### 2. Top-level Julia Script
Then in your Julia script that runs the simulation, ensure to load the `GF180MCUPDK` package as well as `CedarEDA`.
If the Julia package manager asks you to install the package then answer `y`.

```julia
julia> using GF180MCUPDK
 │ Package GF180MCUPDK not found, but a package named GF180MCUPDK is available
 │ from a registry. 
 │ Install package?
 │   (@v1.11) pkg> add GF180MCUPDK 
 └ (y/n/o) [y]: y
julia> using CedarEDA
```

Now to run a simulation with the PDK load `CedarEDA` create a script like so:

```
using CedarEDA
using CedarWaves
using GF180MCUPDK

sm = SimManager("top.spice") # read netlist with .param cload and rload
# Setup 3x3=9 point parameter sweep
params = ProductSweep(
  cload=[10e-12, 20e-12, 50e-12],
  rload=[1000, 10e3, 20e3],
)
sp = SimParameterization(params=params, tspan=(0, 20-e6)) # parameterize netlist
tran1 = tran!(sp) # run transient
inspect(tran1.tran.node_vout) # plot signals

p2p = peak2peak.(tran1.tran.node_vout) # measure P2P voltage of Vout across 9 point sweep
```

The above will run a 2D parameter sweep and make a `peak2peak` measurement of the `vout` node
for each sweep point.

## Version Control
Since `GF180MCUPDK` is a regular Julia package it has version numbers and users can specify which
version of the PDK is compatible with their project or simulator. See the 
[Managing Documentation](https://pkgdocs.julialang.org/v1/managing-packages/) in the 
Pkg [manual](https://pkgdocs.julialang.org/v1/) for more info.
