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
