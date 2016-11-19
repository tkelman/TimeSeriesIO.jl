module TimeSeriesIO

# package code goes here
export TimeArray, DataFrame

using DataFrames
using TimeSeries

import TimeSeries.TimeArray

include("nd_circular_buffer.jl")
include("stream_timearray.jl")

function TimeArray(df::DataFrame; colnames=Symbol[], timestamp=:Date)
    if length(colnames) != 0
        df = df[vcat(timestamp, colnames)]
    else
        colnames = names(df)
        colnames = filter(s->s!=timestamp, colnames)
    end
    colnames_str = [string(s) for s in colnames]
    a_timestamp = Array(df[timestamp])
    a_values = Array(df[colnames])
    ta = TimeArray(a_timestamp, a_values, colnames_str)
    ta
end

function DataFrame(ta::TimeArray; colnames=Symbol[], timestamp=:Date)
    if length(colnames) != 0
        colnames_str = [string(s) for s in colnames]
        ta = ta[colnames_str...]
    end
    df = DataFrame(hcat(ta.timestamp, ta.values))
    colnames = [Symbol(s) for s in ta.colnames]
    colnames = vcat(timestamp, colnames)
    names!(df, colnames)
    df
end

end # module
