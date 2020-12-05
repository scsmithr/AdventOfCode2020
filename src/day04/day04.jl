function alloccursin(needles, haystack)
    found = filter(x->occursin(x, haystack), needles)
    length(found) == length(needles)
end

function readpassports(file)
    s = read(file, String)
    split(s, "\n\n", keepempty=false)
end

function containsrequired(passports)
    fields = ["byr", "iyr", "eyr", "hcl", "ecl", "pid"]
    filter(x->alloccursin(fields, x), passports)
end

day04part1(passports) = length(containsrequired(passports))

function passportfield(field, passport)
    rx = Regex("$field:([a-zA-Z0-9#]*)")
    m = match(rx, passport)
    m.captures[1]
end

function validate_string_as_number(s, min, max)
    n = tryparse(Int, s)
    if n == nothing
        return false
    end
    if n < min || n > max
        return false
    end
    true
end

function validateintfield(field, passport, min, max)
    v = passportfield(field, passport)
    validate_string_as_number(v, min, max)
end

validatebyr(passport) = validateintfield("byr", passport, 1920, 2002)

validateiyr(passport) = validateintfield("iyr", passport, 2010, 2020)

validateeyr(passport) = validateintfield("eyr", passport, 2020, 2030)

function validatehgt(passport)
    v = passportfield("hgt", passport)
    trimmed = v[1:end-2]
    if endswith(v, "cm")
        return validate_string_as_number(trimmed, 150, 193)
    end
    if endswith(v, "in")
        return validate_string_as_number(trimmed, 59, 76)
    end
    false
end

function validatehcl(passport)
    v = passportfield("hcl", passport)
    occursin(r"^#[0-9a-f]{6}$", v)
end

function validateecl(passport)
    v = passportfield("ecl", passport)
    occursin(r"^amb|blu|brn|gry|grn|hzl|oth$", v)
end

function validatepid(passport)
    v = passportfield("pid", passport)
    if length(v) != 9
        return false
    end
    tryparse(Int, v) != nothing
end

validatepassport(p) =
    validatebyr(p) &&
    validateiyr(p) &&
    validateeyr(p) &&
    validatehgt(p) &&
    validatehcl(p) &&
    validateecl(p) &&
    validatepid(p)

filtervalid(passports) = filter(x->validatepassport(x), passports)

day04part2(passports) =
    passports |>
    containsrequired |>
    filtervalid |>
    length

function day04(file)
    passports = readpassports(file)
    p1 = day04part1(passports)
    p2 = day04part2(passports)
    (p1, p2)
end

#=
s1 = """
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:2937 iyr:2017 cid:147 hgt:183cm
"""
alloccursin(["byr", "iyr", "eyr", "hcl", "ecl", "pid"], s1)

file = "day04/input.txt"
passports = readpassports(file)

day04part1(passports)

parse(Int, "hello")

passportfield("ecl", s1)

validatebyr(s1)

day04part2(passports)

=#
