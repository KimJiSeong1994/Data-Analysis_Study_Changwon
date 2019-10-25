# class

# ------------------------------------------------------------------------------------
## "+" function
result = 0

def add(num) :
    global result  # 전역변수 선택하도록
    result += num
    return result

print(add(3)) ; print(add(4))


result1 = 0
result2 = 0

def add1(num):
    global result1
    result1 += num
    return result1

def add2(num):
    global result2
    result2 += num
    return result2

print(add1(3))
print(add1(4))
print(add2(3))
print(add2(7))

# ------------------------------------------------------------------------------------
class Calculator :
    def __init__(self):
        self.result = 0

    def add(self, num):
        self.result += num
        return self.result

cal1 = Calculator()
cal2 = Calculator()

print(cal1.add(3)) ; print(cal1.add(4)) ; print(cal2.add(3)) ; print(cal2.add(7))

def sub(self, num):
    self.result -= num
    return self.result

# ------------------------------------------------------------------------------------
## 사칙연산 클래스 만들기

class FourCal:
    pass

a = FourCal()
type(a)

class FourCal:
    def setdata(self, first, second):
        self.first = first
        self.second = second

a.setdata(4, 2)

a = FourCal()
a.setdata(4, 2)

a = FourCal()
a.setdata(4, 2)
print(a.first) ; print(a.second)

a = FourCal()
b = FourCal()

a.setdata(4, 2)
b.setdata(3, 7)
print(a.first) ; print(b.first)

a = FourCal()
b = FourCal()
a.setdata(4, 2)
b.setdata(3, 7)
id(a.first) ; id(b.first)

class FourCal:
    def setdata(self, first, second):
        self.first = first
        self.second = second

# ------------------------------------------------------------------------------------
## 더하기 기능 만들기

a = FourCal()
a.setdata(4, 2)
print(a.add())

class FourCal:
    def setdata(self, first, second):
        self.first = first
        self.second = second
    def add(self):
        result = self.first + self.second
        return result

a = FourCal()
a.setdata(4, 2)
print(a.add())

# ------------------------------------------------------------------------------------
## 곱하기 빼기 나누기 기능 만들기

class FourCal:
    def setdata(self, first, second):
        self.first = first
        self.second = second

    def add(self):
        result = self.first + self.second
        return result

    def mul(self):
        result = self.first * self.second
        return result

    def sub(self):
        result = self.first - self.second
        return result

    def div(self):
        result = self.first / self.second
        return result

a = FourCal()
b = FourCal()
a.setdata(4, 2)
b.setdata(3, 8)

a.add() ; a.mul() ; a.sub()
b.add() ; b.mul() ; b.sub()

# ------------------------------------------------------------------------------------
## Consructor

a = FourCal()
a.add()

class FourCal:
    def __init__(self, first, second):
        self.first = first
        self.second = second

    def add(self):
        result = self.first + self.second
        return result

    def mul(self):
        result = self.first * self.second
        return result

    def sub(self):
        result = self.first - self.second
        return result

    def div(self):
        result = self.first / self.second
        return result

a = FourCal(4, 2)
print(a.first) ; print(a.second)
a.add()
a.div()

# ------------------------------------------------------------------------------------
## 클래스의 상속

class MoreFourCal(FourCal): # 보통 상속은 기존 클래스를 변경하지 않고 기능을 추가하거나 기존 기능을 변경하려고 할 때 사용
    pass

a = MoreFourCal(4, 2)
a.add()
a.mul()
a.sub()
a.div()

class MoreFourCal(FourCal):
    def pow(self):
        result = self.first ** self.second
        return result

a = MoreFourCal(4, 2)
a.pow()

# ------------------------------------------------------------------------------------
## 메서드 오버라이딩

a = FourCal(4, 0)
a.div()

class SafeFourCal(FourCal) :
    def div(self):
        if self.second == 0:
            return 0
        else :
            return self.first / self.second

a = SafeFourCal(4, 0)
a.div()

# ------------------------------------------------------------------------------------
## 클래스 변수

class Family:
    lastname = "김"

print(Family.lastname)

a = Family()
b = Family()
print(a.lastname) ; print(b.lastname)

Family.lastname = "박"
print(a.lastname) ; print(b.lastname)


