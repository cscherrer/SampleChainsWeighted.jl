module SampleChainsWeighted

using SampleChains, MeasureTheory


using Reexport
@reexport using SampleChains
using NestedTuples
using ElasticArrays
using StructArrays
using ConcreteStructs
using MappedArrays
using Random

export WeightedChain

@concrete struct  WeightedChain{T} <: AbstractChain{T}
    samples     # :: AbstractVector{T}
    logq        # log-density for distribution the sample was drawn from
    logw
    p
    q
    qargs
    rng       
end



# TODO: Fix this to use weights
SampleChains.summarize(ch::WeightedChain) = summarize(samples(ch))


function SampleChains.pushsample!(chain::WeightedChain{T}, x::
    push!(samples(chain), transform(gettransform(chain), Q.q))
    push!(logp(chain), Q.ℓq)
    push!(info(chain), tree_stats)
end

function SampleChains.step!(chain::WeightedChain)
    
end

function SampleChains.initialize!(rng::Random.AbstractRNG, ::Type{WeightedChain}, p, q, qargs)
    qa = q(qargs...)
    x = rand(rng, qa)
    logq = logdensity(qa, x)
    logw = logdensity(p, x) - logq

    chain = WeightedChain(x, logq, logw, p, q, qargs, rng)
end

function SampleChains.initialize!(::Type{WeightedChain}, ℓ, tr, ad_backend=Val(:ForwardDiff))
    rng = Random.GLOBAL_RNG
    return initialize!(rng, WeightedChain, p, q, qargs)
end

function WeightedChain(x::T, logq, logw, p, q, qargs, rng) where {T}
    samples = chainvec(x)
    logq = chainvec(logq)
    logw = chainvec(logw)
    qargs = chainvec(qargs)
    state = chainvec(rng)

    return WeightedChain{T}(samples, logp, logw, p, q, qargs, state)
end

function SampleChains.drawsamples!(chain::WeightedChain, n::Int=1000)
    @cleanbreak for j in 1:n
        Q, tree_stats = step!(chain)
        pushsample!(chain, Q, tree_stats)
    end 
    return chain
end


end
