@enum BspSide Upper Lower

function parseside(c)
    if c == 'F' || c == 'L'
        return Lower
    end
    Upper
end

function parsesides(s)
    sides = Vector{BspSide}(undef, length(s))
    for (i, c) in enumerate(s)
        sides[i] = parseside(c)
    end
    sides
end

function bsprange(r, sides)
    a = collect(r)
    f, l = first(a), last(a)
    for s in sides
        if s == Upper
            f = f + ceil((l-f)/2)
        else
            l = l - ceil((l-f)/2)
        end
    end
    (f, l)
end

function seatpos(sides)
    rowsides = sides[1:7]
    colsides = sides[8:end]
    row = bsprange(0:127, rowsides)[1]
    col = bsprange(0:7, colsides)[1]
    (row, col)
end

function calcseatid(s)
    sides = parsesides(s)
    (row, col) = seatpos(sides)
    Int(row * 8 + col)
end

calcseadids(ss) = map(calcseatid, ss)

function readseats(file)
    s = read(file, String)
    split(s, "\n", keepempty=false)
end

function day05part1(ss)
    ids = calcseadids(ss)
    maximum(ids)
end

function day05part2(ss)
    ids = calcseadids(ss)
    maxid = 127*8*7
    filled = zeros(maxid)
    for id in ids
        filled[id+1] = 1
    end
    start = findfirst(x->x == 1, filled)
    idx = findfirst(x->x == 0, filled[start:end]) + start - 1
    idx-1
end

function day05(file)
    ss = readseats(file)
    p1 = day05part1(ss)
    p2 = day05part2(ss)
    (p1, p2)
end

#=

a = 0:127
@show Vector(a)

min(firstindex(a))

sides = parsesides("FBFBBFF")
bsprange(0:127, sides)

sides2 = parsesides("FBFBBFFRLR")
seatpos(sides2)

calcseatid("FBFBBFFRLR")
calcseatid("BFFFBBFRRR")
calcseatid("FFFBBBFRRR")
calcseatid("BBFFBBFRLL")

ss = readseats("day05/input.txt")
day05part1(ss)
day05part2(ss)

day05("day05/input.txt")
=#
