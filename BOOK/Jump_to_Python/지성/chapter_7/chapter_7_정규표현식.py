# 정규표현식
## 정규표현식을 사용해야하는 이유

# ------------------------------------------------------------------------
data = """
park 800905-1049118
kim 700905-1059119
"""

result = []
for line in data.split("\n") :
    word_result = []
    for word in line.split(" ") :
        if len(word) == 14 and word[:6].isdigti() and word[7:].isdigit() :
            word = word[:6] + "-" + "*******"
        word_result.append(word)
    result.append(" ".join(word_result))
print("\n".join(result))

import re
pat = re.compile("(\d{6}[-]\d{7})")
print(pat.sub("\g<1>-*******", data)) # 정규표현식을 사용할 경우 훨씬 간편하게 사용할수 있다.

import re # 정규표현식 모듈
p = re.compile("ab*")
p = re.compile("[a-z]+")

m = p.match("3 python") # str_detect in R function
print(m)

m = p.search("3 python")
print(m)

result = p.findall("life is too short") # 각각의 단어들을 [a-z]+ 정규표현식과 매치해서 리스트로 출력
print(result)

result = p.finditer("life is too short") # findall과 같은 출력을 하지만 반복 가능한 객체(match 되어 나오는 객체)가 포함되도록 출력
print(result)
for r in result : print(r)

m = p.match("python")
m.group() # 매치된 문자열 출력
m.start() # 매치된 문자열의 시작 자리수를 출력
m.end() #매치된 문자열의 자리수 끝은 출력
m.span() # 매치된 문자열의 시작 끝 자리수를 튜플형태로 출력 (start + end => 튜블)

# ------------------------------------------------------------------------
## 컴파일 옵션

import re
p = re.compile("a.b")
m = p.match("a\nb")
print(m)

p = re.compile("a.b", re.DOTALL) # re.DOTALL = \\ function in R
m = p.match("a\nb")
print(m)

p = re.compile("[a-z]]", re.I) # I = 대소문자 구별 없이 매치를 수행하도록 하는 옵션
p.match("python")
p.match("Python")
p.match("PYTHON")

p = re.compile("^python\s\w+")

data = """python one
life is too short
python two
you need python
python three"""

print(p.findall(data))

p = re.compile("^python\s\w+", re.MULTILINE) # ^, $ option 사용이 가능하도록 추가해줌
print(p.findall(data))

charref = re.compile(r'&[#](0[0-7]+|[0-9]+|x[0-9a-fA-F]+);')
charref = re.compile(r"""
 &[#]                # Start of a numeric entity reference
 (
     0[0-7]+         # Octal form
   | [0-9]+          # Decimal form
   | x[0-9a-fA-F]+   # Hexadecimal form
 )
 ;                   # Trailing semicolon
""", re.VERBOSE) # VERBOSE = 정규표현식을 주석 또는 줄 단위로 구분할수 있도록  해주는 함수

p = re.compile('\\section')
>>> p = re.compile('\\\\section')
p = re.compile(r'\\section')

