import java.net.Socket
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.PrintWriter
import java.util.Scanner

fun main() {
    try {
        val socket = Socket("127.0.0.1", 8080)
        val input = BufferedReader(InputStreamReader(socket.inputStream))
        val output = PrintWriter(socket.outputStream, true)
        val scanner = Scanner(System.`in`)

        println("Успешное подключение! Введите выражение (например '5 + 3') или 'exit':")

        while (true) {
            print("> ")
            val expr = scanner.nextLine()
            if (expr.lowercase() == "exit") break

            output.println(expr)
            val response = input.readLine() ?: break
            println("Сервер: $response")
        }
        socket.close()
    } catch (e: Exception) {
        println("Ошибка подключения: ${e.message}")
    }
}

// kotlinc server.kt -include-runtime -d server.jar && java -jar server.jar

// kotlinc client.kt -include-runtime -d client.jar && java -jar client.jar