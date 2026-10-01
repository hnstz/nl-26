use std::sync::Arc;
use std::thread;
use std::time::Instant;

fn main() {
    let size = 100_000_000usize;
    let data: Vec<i64> = (1..=size as i64).collect();
    let data = Arc::new(data); 

    println!("Массив создан: {} элементов", size);
    println!("---");

    // Однопоточное вычисление
    let start = Instant::now();
    let sum_single = sum_single_thread(&data);
    let duration_single = start.elapsed();

    println!("Однопоточное вычисление:");
    println!("  Сумма: {}", sum_single);
    println!("  Время: {:?}", duration_single);
    println!("---");

    // Многопоточное вычисление
    let num_threads = 4;
    let start = Instant::now();
    let sum_parallel = sum_parallel(&data, num_threads);
    let duration_parallel = start.elapsed();

    println!("Параллельное вычисление ({} потоков):", num_threads);
    println!("  Сумма: {}", sum_parallel);
    println!("  Время: {:?}", duration_parallel);
    println!("---");

    let speedup = duration_single.as_secs_f64() / duration_parallel.as_secs_f64();
    println!("Ускорение: {:.2}x", speedup);
}

fn sum_single_thread(data: &[i64]) -> i64 {
    data.iter().sum()
}

fn sum_parallel(data: &Arc<Vec<i64>>, num_threads: usize) -> i64 {
    let chunk_size = (data.len() + num_threads - 1) / num_threads;
    let mut handles = vec![];

    for i in 0..num_threads {
        let start = i * chunk_size;
        let end = std::cmp::min(start + chunk_size, data.len());
        if start >= data.len() {
            break;
        }

        let data_clone = Arc::clone(data);

        let handle = thread::spawn(move || {
            data_clone[start..end].iter().sum::<i64>()
        });
        handles.push(handle);
    }

    let mut total_sum = 0;
    for handle in handles {
        total_sum += handle.join().unwrap();
    }
    total_sum
}