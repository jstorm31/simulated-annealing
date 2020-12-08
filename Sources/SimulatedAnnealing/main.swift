let simulatedAnnealing = SimulatedAnnealing()

do {
    try simulatedAnnealing.run()
} catch {
    print("Whoops! An error occurred when running the program: \(error)")
}
