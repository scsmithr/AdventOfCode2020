function readgroups(file)
    s = read(file, String)
    split(s, "\n\n", keepempty=false)
end

function dedup_group_answers(answers)
    s = join(answers)
    unique(s)
end

count_unique_answers(answers) = length(dedup_group_answers(answers))

function dedup_group_answers_all(answers)
    s = join(answers)
    needed = length(answers)
    s = filter(c1->count(c2->c2==c1, s) == needed, s)
    unique(s)
end

count_unique_answers_all(answers) = length(dedup_group_answers_all(answers))

function day06part1(groups_ss)
    mapreduce(x->count_unique_answers(split(x, "\n", keepempty=false)), +, groups_ss)
end

function day06part2(groups_ss)
    mapreduce(x->count_unique_answers_all(split(x, "\n", keepempty=false)), +, groups_ss)
end

function day06(file)
    groups = readgroups(file)
    p1 = day06part1(groups)
    p2 = day06part2(groups)
    (p1, p2)
end

#=
s = """
abcx
abcy
abcz
"""
a = split(s, "\n", keepempty=false)
dedup_group_answers(a)
dedup_group_answers_all(a)

dedup_group_answers_all(["b"])

s2 = """
abc

a
b
c

ab
ac

a
a
a
a

b
"""
ss2 = split(s2, "\n\n", keepempty=false)
count_unique_answers_all(split(ss2[5], "\n", keepempty=false))

groups = readgroups("day06/input.txt")
day06part1(groups)
day06part2(groups)

day06("day06/input.txt")
=#
