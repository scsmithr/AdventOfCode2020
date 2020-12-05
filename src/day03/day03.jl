"Parse a tree grid from a string."
function parsetreegrid(s)
    lines = split(s, "\n", keepempty=false)
    width = length(lines[1])
    height = length(lines)
    grid = zeros(Int8, height, width)
    for (i, line) in enumerate(lines)
        for (j, c) in enumerate(line)
            if c == '#'
                grid[i, j] = 1
            end
        end
    end
    grid
end

function walktreegrid(grid, right, down)
    count = 0
    pos = (1,1)
    sz = size(grid)
    while pos[1] <= sz[1]
        if grid[pos...] == 1
            count += 1
        end
        pos = (pos[1]+down, pos[2]+right)
        if pos[2] > sz[2]
            pos = (pos[1], pos[2] % sz[2])
        end
    end
    count
end

day03part1(s) = s |> parsetreegrid |> x->walktreegrid(x, 3, 1)

function day03part2(s)
    grid = parsetreegrid(s)
    dirs = [(1,1), (3,1), (5,1), (7,1), (1,2)]
    mapreduce(x->walktreegrid(grid, x...), *, dirs)
end

function day03(input)
    s = read(input, String)
    p1 = day03part1(s)
    p2 = day03part2(s)
    (p1, p2)
end

#=

s = """
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
"""
grid = parsetreegrid(s)

walktreegrid(grid, (1,1)...)

input = read("day03/input.txt", String)
parsetreegrid(input)

day03part1(input)
day03part2(input)

=#
