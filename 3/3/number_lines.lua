local input_file = arg[1] or "input.txt"
local output_file = arg[2] or "output.txt"

local file_in, err_in = io.open(input_file, "r")
if not file_in then
    print("Ошибка при открытии входного файла: " .. err_in)
    os.exit(1)
end

local file_out, err_out = io.open(output_file, "w")
if not file_out then
    print("Ошибка при открытии выходного файла: " .. err_out)
    file_in:close()
    os.exit(1)
end

local line_number = 1
for line in file_in:lines() do
    file_out:write(string.format("%d: %s\n", line_number, line))
    line_number = line_number + 1
end

file_in:close()
file_out:close()
print("Обработка завершена. Результат в файле: " .. output_file)