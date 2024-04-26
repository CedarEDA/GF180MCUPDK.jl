using Documenter
using GF180MCUPDK

makedocs(
    sitename = "GF180MCUPDK",
    format = Documenter.HTML(),
    modules = [GF180MCUPDK],
)

deploydocs(
    repo = "github.com/CedarEDA/GF180MCUPDK.jl.git",
)
