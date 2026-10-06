//> using scala "3.3"
//> using dep "org.scala-lang.modules::scala-xml:2.2.0"
//> using dep "com.lihaoyi::ujson:3.1.3"

import scala.xml.{XML, Elem}
import java.io.{File, PrintWriter}

@main def convertXmlToJson(): Unit = {
  val inputFile = new File("input.xml")
  if (!inputFile.exists()) {
    println("Ошибка: файл input.xml не найден.")
    sys.exit(1)
  }

  val root = XML.loadFile(inputFile)

  val jsonList = root.child.collect {
    case node: Elem =>
      val fields = node.child.collect {
        case child: Elem => child.label -> ujson.Str(child.text.trim)
      }
      ujson.Obj.from(fields)
  }

  val jsonArray = ujson.Arr.from(jsonList)

  val pw = new PrintWriter(new File("output.json"))
  pw.write(ujson.write(jsonArray, indent = 4))
  pw.close()

  println("Конвертация успешно завершена. Данные сохранены в output.json")
}

// scala xml_to_json.scala