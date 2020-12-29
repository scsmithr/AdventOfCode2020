function is_sum_of_pair(arr, num)
    n = length(arr)
    for i=1:n, j=1:n
        if i == j
            continue
        end
        if arr[i] + arr[j] == num
            return true
        end
    end
    false
end

#=
is_sum_of_pair(1:25, 49)
=#

function find_first_invalid(arr, preamble_size)
    for i=preamble_size+1:length(arr)
        check_arr = @view arr[i-preamble_size:i]
        if !is_sum_of_pair(check_arr, arr[i])
            return arr[i]
        end
    end
    nothing
end

function contiguous_set(arr, num)
    for i=1:length(arr)
        s = arr[i]
        for j=i+1:length(arr)
            s += arr[j]
            if s == num
                return @view arr[i:j]
            end
            if s > num
                break
            end
        end
    end
    nothing
end



function day09part1(arr)
    find_first_invalid(arr, 25)
end

function day09part2(arr)
    num = find_first_invalid(arr, 25)
    contig = contiguous_set(arr, num)
    minimum(contig) + maximum(contig)
end

function day09(file)
    s = read(file, String)
    arr = map(x->parse(Int, x), split(s, "\n", keepempty=false))
    (day09part1(arr), day09part2(arr))
end

#=
day09("input.txt")
=#
