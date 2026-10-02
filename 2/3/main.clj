(ns maze.bfs)

(def maze
  [[0 0 1 0 0 0]
   [1 0 1 0 1 0]
   [0 0 0 0 1 0]
   [0 1 1 1 1 0]
   [0 0 0 0 0 0]])

(def directions [[-1 0] [1 0] [0 -1] [0 1]])

(defn free-neighbors [maze [r c]]
  (for [[dr dc] directions
        :let [nr (+ r dr)
              nc (+ c dc)]
        :when (and (< -1 nr (count maze))
                   (< -1 nc (count (first maze)))
                   (zero? (get-in maze [nr nc])))]
    [nr nc]))

(defn restore-path [parents end]
  (->> (iterate parents end)
       (take-while some?)
       reverse))

(defn bfs [maze start end]
  (loop [queue   (conj clojure.lang.PersistentQueue/EMPTY start)
         parents {start nil}]
    (when-let [current (peek queue)]
      (if (= current end)
        (restore-path parents end)
        (let [new-cells (remove #(contains? parents %)
                                (free-neighbors maze current))]
          (recur (into (pop queue) new-cells)
                 (reduce #(assoc %1 %2 current) parents new-cells)))))))

(defn -main []
  (let [start [0 0]
        end   [4 5]
        path  (bfs maze start end)]
    (if path
      (do (println "Кратчайший путь найден!")
          (println "Длина в шагах:" (dec (count path)))
          (println "Путь:" (vec path)))
      (println "Путь не существует"))))

(-main)
