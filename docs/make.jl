using SampleChainsWeighted
using Documenter

DocMeta.setdocmeta!(SampleChainsWeighted, :DocTestSetup, :(using SampleChainsWeighted); recursive=true)

makedocs(;
    modules=[SampleChainsWeighted],
    authors="Chad Scherrer <chad.scherrer@gmail.com> and contributors",
    repo="https://github.com/cscherrer/SampleChainsWeighted.jl/blob/{commit}{path}#{line}",
    sitename="SampleChainsWeighted.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://cscherrer.github.io/SampleChainsWeighted.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/cscherrer/SampleChainsWeighted.jl",
)
