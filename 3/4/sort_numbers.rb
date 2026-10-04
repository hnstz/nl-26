input_file = ARGV[0] || 'numbers.txt'
output_file = ARGV[1] || 'result.txt'

begin
  numbers = File.readlines(input_file).map(&:to_f)

  if numbers.empty?
    puts "Ошибка: файл пуст или не содержит чисел."
    exit
  end

  sorted_numbers = numbers.sort

  min = sorted_numbers.first
  max = sorted_numbers.last
  sum = sorted_numbers.sum
  avg = sum / sorted_numbers.size.to_f

  File.open(output_file, 'w') do |file|
    file.puts "Отсортированные числа:"
    file.puts sorted_numbers
    file.puts "\nСтатистика:"
    file.puts "Минимум: #{min}"
    file.puts "Максимум: #{max}"
    file.puts "Среднее: #{avg.round(4)}"
  end

  puts "Обработка завершена. Результат записан в #{output_file}"

rescue Errno::ENOENT
  puts "Ошибка: входной файл '#{input_file}' не найден."
rescue => e
  puts "Произошла непредвиденная ошибка: #{e.message}"
end