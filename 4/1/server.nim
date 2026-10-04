import net

proc runServer() =
  let server = newSocket()
  server.bindAddr(Port(8080))
  server.listen()
  echo "Сервер запущен на порту 8080. Ожидание подключений..."

  var client: Socket
  var address = ""

  while true:
    server.acceptAddr(client, address)
    echo "Подключен клиент: ", address
    try:
      while true:
        let line = client.recvLine()
        if line == "": 
          break
        echo "Получено от ", address, ": ", line
        client.send(line & "\c\L")
    except:
      echo "Ошибка: потеряно соединение с клиентом ", address
    finally:
      client.close()
      echo "Соединение с ", address, " закрыто"

runServer()