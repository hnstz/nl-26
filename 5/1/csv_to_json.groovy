import groovy.json.JsonBuilder

def inputFile = new File('input.csv')
def outputFile = new File('output.json')

if (!inputFile.exists()) {
    println "Ошибка: файл input.csv не найден."
    System.exit(1)
}

def lines = inputFile.readLines()
if (lines.isEmpty()) {
    println "Ошибка: файл пуст."
    System.exit(1)
}

def headers = lines[0].split(',').collect { it.trim() }
def dataList = []

for (int i = 1; i < lines.size(); i++) {
    if (lines[i].trim().isEmpty()) continue
    
    def values = lines[i].split(',').collect { it.trim() }
    def rowMap = [:]
    
    for (int j = 0; j < headers.size(); j++) {
        rowMap[headers[j]] = j < values.size() ? values[j] : ""
    }
    dataList << rowMap
}

def json = new JsonBuilder(dataList).toPrettyString()
outputFile.write(json)

println "Конвертация успешно завершена. Данные сохранены в output.json"