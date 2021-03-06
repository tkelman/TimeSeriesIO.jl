using TimeSeriesIO: NDCircularBuffer, capacity, isfull, getindex

using Base.Test

#cb = CircularBuffer{Int}(5)
cb = NDCircularBuffer(Int, 5)
@test length(cb) == 0
@test capacity(cb) == 5
# throws ArgumentError on v0.4 and BoundsError on v0.5 (diverged at 0.5.0-dev+5230)
#if VERSION >= v"0.5.0-dev+5230"
#    @test_throws BoundsError first(cb)
#else
#    @test_throws ArgumentError first(cb)
#end
@test isempty(cb) == true
@test isfull(cb) == false

push!(cb, 1)
@test length(cb) == 1
@test capacity(cb) == 5
@test isfull(cb) == false

append!(cb, 2:8)
@test length(cb) == capacity(cb)
@test size(cb) == (length(cb),)
@test isempty(cb) == false
@test isfull(cb) == true
@test convert(Array, cb) == Int[4,5,6,7,8]
@test cb[1] == 4
@test cb[2] == 5
@test cb[3] == 6
@test cb[4] == 7
@test cb[5] == 8
@test_throws BoundsError cb[6]
@test_throws BoundsError cb[3:6]
@test cb[3:4] == Int[6,7]
@test cb[[1,5]] == Int[4,8]

cb[3] = 999
@test convert(Array, cb) == Int[4,5,999,7,8]

cb = NDCircularBuffer(Int, 3, 4)
#println(convert(Array, cb))
@test size(cb) == (0, 4)
println(cb)
push!(cb, [10, 11, 12, 13])
@test size(cb) == (1, 4)
push!(cb, [20, 21, 22, 23])
@test size(cb) == (2, 4)
push!(cb, [30, 31, 32, 33])
@test size(cb) == (3, 4)
push!(cb, [40, 41, 42, 43])
push!(cb, [50, 51, 52, 53])
@test cb[end-2] == [30,31,32,33]
@test cb[end-1] == [40,41,42,43]
@test cb[end] == [50,51,52,53]
println(cb.buffer)

#ToFix
cb[end, 2] = 99
@test cb[end] == [50,99,52,53]

#println(cb.colons)
#println(cb.buffer[1, :])
#println(cb[1])
#println(convert(Array, cb))
