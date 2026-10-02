using Base.Threads

function sequential_matmul(A, B)
    n, m = size(A)
    p = size(B, 2)
    C = zeros(n, p)
    for i in 1:n, j in 1:p
        s = 0.0
        for k in 1:m
            s += A[i, k] * B[k, j]
        end
        C[i, j] = s
    end
    return C
end

function parallel_matmul(A, B)
    n, m = size(A)
    p = size(B, 2)
    C = zeros(n, p)
    @threads for i in 1:n
        for j in 1:p
            s = 0.0
            for k in 1:m
                s += A[i, k] * B[k, j]
            end
            C[i, j] = s
        end
    end
    return C
end

function main()
    n = 500
    A = rand(n, n)
    B = rand(n, n)
    println("Количество потоков: ", nthreads())

    sequential_matmul(A, B)
    parallel_matmul(A, B)

    t_seq = @elapsed C_seq = sequential_matmul(A, B)
    t_par = @elapsed C_par = parallel_matmul(A, B)

    println("Последовательно: ", round(t_seq, digits=3), " с")
    println("Параллельно:     ", round(t_par, digits=3), " с")
    println("Ускорение: ", round(t_seq / t_par, digits=2), "x")
    println("Результаты совпадают: ", C_seq ≈ C_par)
end

main()