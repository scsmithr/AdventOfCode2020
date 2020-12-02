using DelimitedFiles
using IterTools

function find_tuple_2020(arr, size, def)
    for t in subsets(arr, size)
        if sum(t) == 2020
            return t
        end
    end
    def
end

day1part1(arr) = prod(find_tuple_2020(arr, 2, (0,0)))
day1part2(arr) = prod(find_tuple_2020(arr, 3, (0,0,0)))

function day1(path)
    arr = readdlm("day01/input.txt", Int)
    p1 = day1part1(arr)
    p2 = day1part2(arr)
    (p1, p2)
end

#=
a = [1000, 1721, 979, 366, 299, 675, 1456]
subsets(a, 2)

find_tuple_2020([1000, 1721, 979, 366, 299, 675, 1456], 2, (0,0))

day1("day01/day01.jl")
=#
