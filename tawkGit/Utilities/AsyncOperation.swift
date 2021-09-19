//
//  AsyncOperation.swift
//  tawkGit
//
//  Created by Nazmul Islam on 19/9/21.
//

import Foundation

class AsyncOperation: Operation {
    enum State {
        case ready, executing, finished

        func keyPath() -> String {
            switch self {
                case .ready:
                    return "isReady"
                case .executing:
                    return "isExecuting"
                case .finished:
                    return "isFinished"
            }
        }
    }

    override var isReady: Bool {
        state == .ready
    }

    override var isExecuting: Bool {
        state == .executing
    }

    override var isFinished: Bool {
        state == .finished
    }

    override var isAsynchronous: Bool {
        return true
    }

    var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath())
            willChangeValue(forKey: state.keyPath())
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath())
            didChangeValue(forKey: state.keyPath())
        }
    }

    override func cancel() {
        super.cancel()
        state = .finished
    }

    func isDependencyCancelled() -> Bool {
        for dependency in dependencies {
            if dependency.isCancelled {
                return true
            }
        }
        return false
    }

    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        state = .executing
        main()
    }
}
