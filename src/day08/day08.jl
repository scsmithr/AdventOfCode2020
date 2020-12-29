abstract type AbstractInstruction end

struct Nop <: AbstractInstruction
    arg::Int64
end

struct Acc <: AbstractInstruction
    arg::Int64
end

struct Jmp <: AbstractInstruction
    arg::Int64
end

execute(acc::Int64, pc, ins::AbstractInstruction) = (acc, pc + 1)
execute(acc::Int64, pc, ins::Acc) = (acc += ins.arg, pc + 1)
execute(acc::Int64, pc, ins::Jmp) = (acc, pc += ins.arg)

function parse_instruction(str)
    rx = r"([a-z]+) ([\+|-][0-9]+)"
    m = match(rx, str)
    ins = m.captures[1]
    arg = parse(Int64, m.captures[2])

    ins == "nop" && return Nop(arg)
    ins == "acc" && return Acc(arg)
    ins == "jmp" && return Jmp(arg)

    error("could not parse instruction: '$(str)'")
end

parse_instructions(str) = map(parse_instruction, split(str, "\n", keepempty=false))

struct FlippedInstructionVector <: AbstractVector{AbstractInstruction}
    orig::Vector{AbstractInstruction}
    flipped_idx::Int64
end

Base.size(A::FlippedInstructionVector) = size(A.orig)

function Base.getindex(A::FlippedInstructionVector, i::Int)
    if i == A.flipped_idx
        arg = A.orig[i].arg
        return typeof(A.orig[i]) == Jmp ? Nop(arg) : Jmp(arg)
    end
    A.orig[i]
end

#=
parse_instruction("nop +0")
parse_instruction("jmp -3")
parse_instruction("acc +99")

ins_str = """
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
"""
ins = parse_instructions(ins_str)
=#

function has_duplicate_pc(pc, tracked_pcs)
    findfirst(isequal(pc), tracked_pcs) != nothing
end

function run_instructions(ins::AbstractVector{AbstractInstruction})
    tracked_pcs = Vector{Int64}(undef, 0)
    push!(tracked_pcs, 1)
    (acc, pc) = execute(0, 1, ins[1])
    while !has_duplicate_pc(pc, tracked_pcs)
        if pc == length(ins) + 1
            break
        end
        push!(tracked_pcs, pc)
        curr = ins[pc]
        (acc, pc) = execute(acc, pc, curr)
    end
    terminates = !has_duplicate_pc(pc, tracked_pcs)
    (acc, terminates)
end

function gen_flipped_instructions(ins::AbstractVector{AbstractInstruction})
    idxs = findall(x-> typeof(x) == Jmp || typeof(x) == Nop, ins)
    all_possible = Vector{FlippedInstructionVector}(undef, length(idxs))
    for (i, flipped_idx) in enumerate(idxs)
        all_possible[i] = FlippedInstructionVector(ins, flipped_idx)
    end
    all_possible
end

function find_fixed_instructions(ins::AbstractVector{AbstractInstruction})
    vv = gen_flipped_instructions(ins)
    for v in vv
        (acc, terminated) = run_instructions(v)
        if terminated
            return (acc, v)
        end
    end
    nothing
end


#=
run_instructions(ins)

gen_flipped_instructions(ins)
find_fixed_instructions(ins)
=#

function day08part1(ins)
    (acc, _) = run_instructions(ins)
    acc
end

function day08part2(ins)
    (acc, _) = find_fixed_instructions(ins)
    acc
end

function day08(file)
    s = read(file, String)
    ins = parse_instructions(s)
    (day08part1(ins), day08part2(ins))
end

#=
day08("input.txt")
=#
