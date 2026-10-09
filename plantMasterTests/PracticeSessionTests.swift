import Testing
@testable import plantMaster

@MainActor
struct PracticeSessionTests {
    private func makePlants() -> [Plant] {
        [
            Plant(index: 1, latinName: "Acer campestre", dutchName: "veldesdoorn, Spaanse aak"),
            Plant(index: 2, latinName: "Acer platanoides", dutchName: "Noorse esdoorn"),
            Plant(index: 3, latinName: "Alnus glutinosa", dutchName: "zwarte els"),
        ]
    }

    @Test func missedQuestionsComeBackUntilCorrect() {
        let session = PracticeSession()
        session.start(mode: .dutchToLatin, with: makePlants())
        #expect(session.questions.count == 3)

        // Get the first one wrong, the other two right.
        let missedPlant = session.currentQuestion!.target
        session.typedLatin = "wrong"
        session.submit()
        #expect(!session.lastAnswerWasCorrect)
        #expect(!session.isLastQuestion)
        session.advance()

        for _ in 0..<2 {
            session.typedLatin = session.currentQuestion!.target.latinName
            session.submit()
            #expect(session.lastAnswerWasCorrect)
            session.advance()
        }

        // Main round done, retry phase begins with the missed plant.
        #expect(session.isInRetryPhase)
        #expect(!session.isFinished)
        #expect(session.currentQuestion?.isRetry == true)
        #expect(session.currentQuestion?.target.index == missedPlant.index)
        #expect(session.isLastQuestion)

        // Miss it again: it must be re-queued and the session must not end.
        session.typedLatin = "still wrong"
        session.submit()
        session.advance()
        #expect(!session.isFinished)
        #expect(session.retryQueue.count == 1)
        #expect(session.retriesTaken == 1)

        // Get it right: session ends.
        session.typedLatin = missedPlant.latinName
        session.submit()
        #expect(session.lastAnswerWasCorrect)
        session.advance()
        #expect(session.isFinished)
        #expect(session.currentQuestion == nil)

        // Score counts first attempts only; retries don't inflate it.
        #expect(session.score == 2)
        #expect(session.missed.count == 1)
        #expect(session.retriesTaken == 2)
    }

    @Test func perfectRoundHasNoRetryPhase() {
        let session = PracticeSession()
        session.start(mode: .dutchToLatin, with: makePlants())

        while let question = session.currentQuestion {
            session.typedLatin = question.target.latinName
            session.submit()
            session.advance()
        }

        #expect(session.isFinished)
        #expect(session.score == 3)
        #expect(session.retriesTaken == 0)
        #expect(session.missed.isEmpty)
    }

    @Test func examRequiresBothNamesAndAcceptsDutchAlternatives() {
        let session = PracticeSession()
        session.start(mode: .exam, with: [Plant(index: 1, latinName: "Acer campestre", dutchName: "veldesdoorn, Spaanse aak")])

        session.typedDutch = "spaanse aak"
        session.typedLatin = "acer campestre"
        #expect(session.canSubmit)
        session.submit()
        #expect(session.dutchCorrect)
        #expect(session.latinCorrect)
        #expect(session.lastAnswerWasCorrect)
    }
}

@MainActor
struct PhotoRotationTests {
    private func photos(_ count: Int) -> [PlantPhoto] {
        (0..<count).map { PlantPhoto(filename: "p\($0).jpg", sortOrder: $0) }
    }

    @Test func picksOnlyAmongLeastShown() {
        let set = photos(3)
        set[0].timesShown = 2
        set[1].timesShown = 0
        set[2].timesShown = 0
        for _ in 0..<50 {
            let picked = PhotoRotation.pick(from: set)!
            #expect(picked.filename != "p0.jpg")
        }
    }

    @Test func everyPhotoShownBeforeAnyRepeats() {
        let set = photos(3)
        for _ in 0..<5 {
            var seen = Set<String>()
            for _ in 0..<3 {
                let picked = PhotoRotation.pick(from: set)!
                seen.insert(picked.filename)
                PhotoRotation.markShown(picked)
            }
            #expect(seen.count == 3)
        }
    }

    @Test func twoPhotosAlternate() {
        let set = photos(2)
        var last: String?
        for _ in 0..<10 {
            let picked = PhotoRotation.pick(from: set)!
            #expect(picked.filename != last)
            last = picked.filename
            PhotoRotation.markShown(picked)
        }
    }

    @Test func noPhotosPicksNothing() {
        #expect(PhotoRotation.pick(from: []) == nil)
    }
}
