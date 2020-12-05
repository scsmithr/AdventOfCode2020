struct Policy
    a::Int
    b::Int
    letter::Char
end

struct Password
    value::AbstractString
    policy::Policy
end

"Parse a password and its policy from a string."
function parsepassword(s)
    rx = r"([0-9]+)-([0-9]+) ([a-zA-Z]): ([a-zA-Z]+)" # "1-3 a: abcdae"
    m = match(rx, s)
    pol = Policy(parse(Int, m.captures[1]), parse(Int, m.captures[2]), m.captures[3][1])
    pass = Password(m.captures[4], pol)
end

"Validate a password with its policy by letter count."
function validpasswordcount(p)
    rx = Regex(string(p.policy.letter))
    count = length(collect(eachmatch(rx, p.value)))
    count >= p.policy.a && count <= p.policy.b
end

"Validate password based on letter position."
function validpasswordpos(p)
    a = p.value[p.policy.a]
    b = p.value[p.policy.b]
    a_valid = a == p.policy.letter
    b_valid = b == p.policy.letter
    (a_valid || b_valid) && !(a_valid && b_valid)
end

parsepasswords(arr) = map(x->parsepassword(x), arr)

day02part1(arr) = arr |> parsepasswords |> x->filter(validpasswordcount, x) |> length

day02part2(arr) = arr |> parsepasswords |> x->filter(validpasswordpos, x) |> length

function day02(path)
    arr = filter(s->!isempty(s), split(read(path, String), "\n"))
    p1 = day02part1(arr)
    p2 = day02part2(arr)
    (p1, p2)
end

#=
rx = r"([0-9]+)-([0-9]+) (.): ([a-zA-Z]+)"
m = match(rx, "13-3 a: abcde")
m.captures

rx3 = r"a"
match(rx3, "aaaa").captures

rx2 = r"([^x]*x){20,23}"
match(rx2, "xxxxxxxxxxxxxxxxcxx")

p = parsepassword("2-3 a: abcdae")
validpasswordcount(p)
validpasswordpos(p)

arr = filter(s->!isempty(s), split(read("day02/input.txt", String), "\n"))
filter(x->!validpassword(x), parsepasswords(arr))

l = day02part1(arr)

day02("day02/input.txt")

t = """
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
"""
tarr = filter(s->!isempty(s), split(t, "\n"))
day02part1(tarr)

=#
