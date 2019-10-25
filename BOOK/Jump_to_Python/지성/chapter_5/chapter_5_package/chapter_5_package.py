# package

# ------------------------------------------------------------------------------------
# 패키지 안의 함수 실행하기

import game.sound.echo
game.sound.echo.echo_test()

from game.sound import echo
echo.echo_test()

from game.sound.echo import echo_test
echo_test()

# ------------------------------------------------------------------------------------
# __init__.py. 의 용도 : 해당 디렉터리가 패키지의 일부임을 알려주는 역할

# ------------------------------------------------------------------------------------
# relative 패키지

from game.graphic.render import render_test
render_test()
