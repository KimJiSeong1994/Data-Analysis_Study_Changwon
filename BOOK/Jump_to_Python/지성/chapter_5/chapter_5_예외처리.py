# 예외 처리

# ------------------------------------------------------------
## 오류 예외 처리

try:
    a = [1, 2]
    print(a[3])
    4 / 0
except ZeroDivisionError :
    print("0으로 나눌 수 없습니다.")
except IndexError :
    print("인덱싱 할 수 없습니다.")

try:
    a = [1,2]
    print(a[3])
    4/0
except ZeroDivisionError as e:
    print(e)
except IndexError as e:
    print(e)

try:
    a = [1,2]
    print(a[3])
    4/0
except (ZeroDivisionError, IndexError) as e:
    print(e)

# ------------------------------------------------------------
## 오류 회피하기

try:
    f = open("나없는파일", 'r')
except FileNotFoundError:
    pass # 오류를 무시

# ------------------------------------------------------------
## 오류 일부러 발생시키기

class Bird:
    def fly(self):
        raise NotImplementedError

class Eagle(Bird):
    pass

eagle = Eagle()
eagel.fly()

class Eagle(Bird):
    def fly(self):
        print("very fast")

eagle = Eagle()
eagle.fly()

# ------------------------------------------------------------
## 예외 만들기

class MyError(Exception):
    pass

def say_nick(nick):
    if nick == '바보':
        raise MyError()
    print(nick)

say_nick("천사")
say_nick("바보")

try:
    say_nick("천사")
    say_nick("바보")
except MyError:
    print("허용되지 않는 별명입니다.")

try:
    say_nick("천사")
    say_nick("바보")
except MyError as e:
    print(e)


class MyError(Exception):
    def __str__(self):
        return "허용되지 않는 별명입니다."

