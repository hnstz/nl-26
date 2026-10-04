import net

proc runClient() =
  let client = newSocket()
  try:
    client.connect("127.0.0.1", Port(8080))
    echo "Успешное подключение к серверу! Введите сообщение (или 'exit' для выхода)."
    
    while true:
      stdout.write("> ")
      let message = stdin.readLine()
      
      if message == "exit":
        break
        
      client.send(message & "\c\L")
      let response = client.recvLine()
      echo "Эхо от сервера: ", response
  except:
    echo "Ошибка: не удалось подключиться к серверу."
  finally:
    client.close()
    echo "Работа клиента завершена."

runClient()
# nim c -r server.nim
# nim c -r client.nim