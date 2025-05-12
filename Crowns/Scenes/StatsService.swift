import Foundation

enum GameMode: String, CaseIterable, Codable {
    case tango = "Tango"
    case queens = "Queens"
    case sudoku = "Sudoku"
    // Добавьте другие режимы при необходимости
}

struct GameStats: Codable {
    var gamesCompleted: Int = 0
    var totalTime: TimeInterval = 0
    var bestTime: TimeInterval = .greatestFiniteMagnitude

    var averageTime: TimeInterval {
        gamesCompleted == 0 ? 0 : totalTime / Double(gamesCompleted)
    }
}

final class StatsService {
    static let shared = StatsService()
    private let key = "game_stats_v1"

    private var stats: [GameMode: GameStats] = [:]

    private init() {
        load()
    }

    func getStats(for mode: GameMode) -> GameStats {
        stats[mode] ?? GameStats()
    }

    func updateStats(for mode: GameMode, time: TimeInterval) {
        var s = stats[mode] ?? GameStats()
        s.gamesCompleted += 1
        s.totalTime += time
        if time < s.bestTime { s.bestTime = time }
        stats[mode] = s
        save()
    }

    func resetStats() {
        stats = [:]
        save()
    }

    func allStats() -> [GameMode: GameStats] {
        stats
    }

    private func save() {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let loaded = try? JSONDecoder().decode([GameMode: GameStats].self, from: data) else { return }
        stats = loaded
    }
} 