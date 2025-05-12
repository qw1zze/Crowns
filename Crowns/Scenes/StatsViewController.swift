import UIKit

final class StatsViewController: UIViewController {
    private let stack = UIStackView()
    private let resetButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Статистика"
        setupStack()
        setupResetButton()
        layoutUI()
        updateStats()
    }

    private func setupStack() {
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupResetButton() {
        resetButton.setTitle("Сбросить статистику", for: .normal)
        resetButton.setTitleColor(.systemRed, for: .normal)
        resetButton.addTarget(self, action: #selector(resetStats), for: .touchUpInside)
        view.addSubview(resetButton)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func layoutUI() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            resetButton.topAnchor.constraint(greaterThanOrEqualTo: stack.bottomAnchor, constant: 32),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    private func updateStats() {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for mode in GameMode.allCases {
            let stats = StatsService.shared.getStats(for: mode)
            let v = makeStatsView(for: mode, stats: stats)
            stack.addArrangedSubview(v)
        }
    }

    private func makeStatsView(for mode: GameMode, stats: GameStats) -> UIView {
        let title = UILabel()
        title.text = mode.rawValue
        title.font = .boldSystemFont(ofSize: 18)
        let games = UILabel()
        games.text = "Завершено игр: \(stats.gamesCompleted)"
        let avg = UILabel()
        avg.text = "Среднее время: " + (stats.gamesCompleted == 0 ? "-" : formatTime(stats.averageTime))
        let best = UILabel()
        best.text = "Лучшее время: " + (stats.bestTime == .greatestFiniteMagnitude ? "-" : formatTime(stats.bestTime))
        let vStack = UIStackView(arrangedSubviews: [title, games, avg, best])
        vStack.axis = .vertical
        vStack.spacing = 4
        vStack.alignment = .leading
        vStack.layer.cornerRadius = 10
        vStack.backgroundColor = UIColor.secondarySystemBackground
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        return vStack
    }

    private func formatTime(_ t: TimeInterval) -> String {
        let m = Int(t) / 60, s = Int(t) % 60
        return String(format: "%02d:%02d", m, s)
    }

    @objc private func resetStats() {
        let alert = UIAlertController(title: "Сбросить статистику?", message: "Это действие необратимо.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Сбросить", style: .destructive) { _ in
            StatsService.shared.resetStats()
            self.updateStats()
        })
        present(alert, animated: true)
    }
} 