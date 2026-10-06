import std.socket;
import std.stdio;

void main(string[] args) {
    if (args.length < 2) {
        writeln("Использование: ./client <путь_к_файлу>");
        return;
    }
    string filePath = args[1];

    auto client = new TcpSocket();
    client.connect(new InternetAddress("127.0.0.1", 8080));
    writeln("Подключено к серверу. Отправка файла...");

    auto file = File(filePath, "rb");
    long totalSent = 0;

    foreach (chunk; file.byChunk(4096)) {
        client.send(chunk);
        totalSent += chunk.length;
    }

    file.close();
    client.close(); 
    writeln("Файл успешно отправлен. Передано байт: ", totalSent);
}
//source ~/dlang/dmd-2.113.0/activate

// dmd server.d && ./server

// dmd client.d && ./client file_to_send.txt