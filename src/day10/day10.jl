laptop_joltage(adapters) = maximum(adapters) + 3

parse_adapters(s) = map(x->parse(Int, x), split(s, keepempty=false))

#=
adapter_str = """
16
10
15
5
1
11
7
19
6
12
4
"""
adapters = parse_adapters(adapter_str)
start_jolt = 0
end_jolt = laptop_joltage(adapters)
=#

function diff_dist(adapters, start_jolt, end_jolt)
    v = sort([adapters..., start_jolt, end_jolt])
    diffs = diff(v)
    m = maximum(diffs)
    dist = zeros(m)
    for d in diffs
        dist[d] += 1
    end
    dist
end

function num_paths(adapters, start_jolt, end_jolt)
    v = sort([adapters..., start_jolt, end_jolt])
    n = length(v)
    acc_paths = zeros(n)
    acc_paths[1] = 1
    for i in 1:n, j in i+1:i+3
        if j > n
            continue
        end
        if v[j] - v[i] <= 3
            acc_paths[j] += acc_paths[i]
        end
    end
    last(acc_paths)
end


#=
diff_dist(adapters, start_jolt, end_jolt)
=#

function day10part1(adapters)
    start_jolt = 0
    end_jolt = laptop_joltage(adapters)
    dist = diff_dist(adapters, start_jolt, end_jolt)
    dist[1] * dist[3]
end

function day10part2(adapters)
    start_jolt = 0
    end_jolt = laptop_joltage(adapters)
    num_paths(adapters, start_jolt, end_jolt)
end

function day10(file)
    s = read(file, String)
    adapters = parse_adapters(s)
    (day10part1(adapters), day10part2(adapters))
end

#=
day10("input.txt")
=#
