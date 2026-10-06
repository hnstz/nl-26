import java.net.ServerSocket
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.PrintWriter
import kotlin.concurrent.thread

fun evaluate(expr: String): Double {
    val parts = expr.trim().split(Regex("\\s+"))
    if (parts.size != 3) throw IllegalArgumentException("Требуется формат: ЧИСЛО ОПЕРАТОР ЧИСЛО (через пробел)")
    val a = parts[0].toDouble()
    val b = parts[2].toDouble()
    return when (parts[1]) {
        "+" -> a + b
        "-" -> a - b
        "*" -> a * b
        "/" -> a / b
        else -> throw IllegalArgumentException("Неизвестный оператор")
    }
}

fun main() {
    val server = ServerSocket(8080)
    println("Сервер запущен на порту 8080. Ожидание подключений...")

    while (true) {
        val client = server.accept()
        println("Подключен клиент: ${client.inetAddress.hostAddress}")
        
        thread {
            val input = BufferedReader(InputStreamReader(client.inputStream))
            val output = PrintWriter(client.outputStream, true)
            
            try {
                while (true) {
                    val line = input.readLine() ?: break
                    println("Запрос от клиента: $line")
                    try {
                        val result = evaluate(line)
                        output.println("Результат: $result")
                    } catch (e: Exception) {
                        output.println("Ошибка: ${e.message}")
                    }
                }
            } finally {
                client.close()
                println("Клиент отключен.")
            }
        }
    }
}