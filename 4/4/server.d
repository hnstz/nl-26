import std.socket;
import std.stdio;

void main() {
    auto server = new TcpSocket();
    server.bind(new InternetAddress(8080));
    server.listen(1);
    writeln("Сервер запущен на порту 8080. Ожидание файла...");

    auto client = server.accept();
    writeln("Клиент подключен. Начинаем прием...");

    auto file = File("received_file.dat", "wb");
    ubyte[4096] buffer;
    long totalReceived = 0;

    while (true) {
        auto bytesRead = client.receive(buffer);
        if (bytesRead <= 0) break; // 0 означает закрытие соединения, < 0 - ошибку
        
        file.rawWrite(buffer[0 .. bytesRead]);
        totalReceived += bytesRead;
    }

    file.close();
    client.close();
    server.close();
    writeln("Файл успешно сохранен. Получено байт: ", totalReceived);
}