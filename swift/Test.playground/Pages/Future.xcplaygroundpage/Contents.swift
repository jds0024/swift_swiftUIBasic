

import Foundation
import Combine

//future는 하나의 결과를 비동기로 생성한 뒤 copletion event를 보낸다
//Promisesms Future가 값을 내보낼 때 호출되는 클로저 입니다
//init에서 Promise 클로저를 매게 변수르 받는다
//class 로 구현
//다른 publisher는 다 struct인데 future만 클래스인 이유:
    //비동기로 작동할 때 상태 저장 동작을 가능하게 하기위해

let future = Future<Int, Never> { promise in
    promise(.success(1))
    promise(.success(2))
}

future.sink(
    receiveCompletion: { print("completion\($0)") },
            receiveValue: { print($0) }
)

var subscriptions = Set<AnyCancellable>()
var emitValue: Int = 0
var delay: TimeInterval = 3

func createFuture() -> Future<Int, Never> {
    return Future<Int, Never> { promise in
        delay -= 1
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            emitValue += 1
            promise(.success(emitValue))
        }
    }
}

let firstFuture = createFuture()
let secondFuture = createFuture()
let thirdFuture = createFuture()

firstFuture
    .sink(receiveCompletion: { print("첫번째 Future Completion: \($0)") },
          receiveValue: { print("첫번째 Future value: \($0)") })
    .store(in: &subscriptions)

secondFuture
    .sink(receiveCompletion: { print("두번째 Future completion: \($0)") },
          receiveValue: { print("두번째 Future value: \($0)") })
    .store(in: &subscriptions)

thirdFuture
    .sink(receiveCompletion: { print("세번째 Future completion: \($0)") },
          receiveValue: { print("세번째 Future value: \($0)") })
    .store(in: &subscriptions)

thirdFuture
    .sink(receiveCompletion: { print("세번째 Future completion2: \($0)") },
          receiveValue: { print("세번째 Future value2: \($0)") })
    .store(in: &subscriptions)

//https://icksw.tistory.com/273
