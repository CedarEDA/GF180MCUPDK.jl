module GF180MCUPDK

module design
    using CedarSim

    sp"""
    .include "../model/design.ngspice"
    """i

    export cap_mc_skew, fnoicor, mc_skew, res_mc_skew, sw_stat_global, sw_stat_mismatch
end

module sm141064
    using CedarSim
    using BSIM4
    using ..design

    path = joinpath(@__DIR__, "../model/sm141064.ngspice")
    eval(CedarSim.load_spice_modules(path;
        pdk_include_paths=[dirname(path)],
        names=["typical", #="ff", "ss", "fs", "sf",=# "statistical"],
        preload=[CedarSim, CedarSim.SpectreEnvironment, BSIM4, design],
        exports=[:cap_mc_skew, :fnoicor, :mc_skew, :res_mc_skew, :sw_stat_global, :sw_stat_mismatch]
    ))
end

const files = Dict{String,  Module}(
    "sm141064.ngspice" => sm141064
)

function get_module(name::String)
    try
        return files[name]
    catch
        throw(ArgumentError("File \"$name\" not found in $(keys(files))"))
    end
end

using PrecompileTools
using CedarSim
using CedarSim.SpectreEnvironment
using .sm141064.typical
@setup_workload begin
    (;d, g, s, b) = nets()
    🔍 = CedarSim.ParamLens()
    @compile_workload begin
        @ckt_nfet_03v3(nodes=(g, d, s, b), w=1e-6, l=1e-6)
        @ckt_pfet_03v3(nodes=(g, d, s, b), w=1e-6, l=1e-6)
        @ckt_nfet_06v0(nodes=(g, d, s, b), w=1e-6, l=1e-6)
        @ckt_pfet_06v0(nodes=(g, d, s, b), w=1e-6, l=1e-6)
        #TODO add more devices, but these are currently all we seem to use
    end
end

end # module
