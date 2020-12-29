function parserule(rule)
    ss = split(rule, " bags contain ")
    rule = ss[1]
    edges = Vector{typeof(rule)}()
    rest = split(ss[2], ", ")
    rx = r"([0-9]+) ([a-z]+ [a-z]+)"
    for s in rest
        m = match(rx, s)
        if m == nothing
            continue
        end
        num = parse(Int, m.captures[1])
        append!(edges, repeat([m.captures[2]], num))
    end
    (rule, edges)
end

function parserules(rules)
    ss = split(rules, "\n", keepempty=false)
    map(parserule, ss)
end

#=
parserule("light red bags contain 1 bright white bag, 2 muted yellow bags.")
parserule("bright white bags contain 1 shiny gold bag.")
parserule("faded blue bags contain no other bags.")

rules = """
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
"""
parsed_rules = parserules(rules)
=#

function build_graph(parsed_rules::Vector{Tuple{SubString{String}, Vector{SubString{String}}}})
    m = length(parsed_rules)
    # Rows indicate what bags 'this' bag may contain. Columns indicate what bags may
    # contain 'this' bag.
    M = zeros(Int64, (m, m))
    idx_tracker = Dict{AbstractString, Int64}()
    # Just build index tracker first to make updating matrix easy.
    for (i, (bag, _)) in enumerate(parsed_rules)
        idx_tracker[bag] = i
    end
    # Build up matrix.
    for (i, (bag, contains_bags)) in enumerate(parsed_rules)
        for contains_bag in contains_bags
            j = idx_tracker[contains_bag]
            M[i, j] += 1
        end
    end
    (idx_tracker, M)
end

#=
(idxs, M) = build_graph(parsed_rules)
idxs
M
=#

function dfs_walk(f, M, col_idx)
    for (i, val) in enumerate(M[:, col_idx])
        if val == 0
            continue
        end
        f(i, col_idx, val)
        dfs_walk(f, M, i)
    end
end

function coalesce_bag_vals(M, row_idx)
    acc = sum(M[row_idx, :])
    if acc == 0
        return 0
    end
    for (j, val) in enumerate(M[row_idx, :])
        if val == 0
            continue
        end
        acc += val * coalesce_bag_vals(M, j)
    end
    acc
end

#=
dfs_walk((i, j, val)->println("walked $(i) $(j) $(val)"), M, 5)
coalesce_bag_vals(M, 5)
=#

function num_bags_contain(M, idxs, bagstr)
    if !haskey(idxs, bagstr)
        error("No index for bag")
    end
    idx = get(idxs, bagstr, 0)
    walked_bags = Vector{Int64}(undef, 0)
    dfs_walk((i, _, _) -> push!(walked_bags, i), M, idx)
    length(unique(walked_bags))
end

#=
num_bags_contain(M, idxs, "shiny gold")
bag_vals = num_bags_contain_val(M, idxs, "shiny gold")
=#

function day07part1(s)
    parsed_rules = parserules(s)
    (idxs, M) = build_graph(parsed_rules)
    num_bags_contain(M, idxs, "shiny gold")
end

function day07part2(s)
    parsed_rules = parserules(s)
    (idxs, M) = build_graph(parsed_rules)
    coalesce_bag_vals(M, get(idxs, "shiny gold", 0))
end

function day07(file)
    s = read(file, String)
    (day07part1(s), day07part2(s))
end

#=
day07("input.txt")
=#
