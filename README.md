# 오픈소스SW개론 과제

### **1.getopts**

쉘스크립트에서 getopts 명령어의 사용이유는 사용자 혹은 개발자가 쉘스크립트를 사용할때 옵션을 사용하기 용이함을 위함이다.

예를들어 사용자가 포맷 외의 입력을 하여 도움을 주기 위해 도움말을 출력한다던지, 

개발자가 작업을 할때 지정해둔 옵션을 입력하는것 만으로 긴 코드의 반복적인 입력을 줄일 수 있을 것이다.

또한 코드의 가독성을 높여줄수 있기 때문에 코드를 확인할때 편하게 작업을 할 수 있다.

getopts 명령어는 `getopts option_string varname` 으로 구성된다.

아래 코드는 commit 되어 있는 shell.sh 파일의 내용이다. [출처](https://systemdesigner.tistory.com/17 "빠른 이해를 위해 코드를 습득후 공부하였습니다.")

```sh
 #!/bin/bash

## 도움말 출력하는 함수
help() {
        echo "splt [OPTIONS] FILE"
                echo "    -h         도움말 출력."
                echo "    -a ARG     인자를 받는 opt."
                echo "    -b ARG     인자를 받는 opt2."
                exit 0
}
while getopts "a:b:h" opt
  do
    case $opt in
    a) arg_a=$OPTARG
    echo "Arg A: $arg_a"
    ;;
    b) arg_b=$OPTARG
    echo "Arg B: $arg_b"
    echo "$arg_b"
    ;;
    h) help ;;
    ?) help ;;
    esac
  done
```

* **option_string** 부분은 옵션을 정의하는 문자이다. 
  * 예를들어 ***h***라는 옵션을 입력하면 개발자가 지정한 ***h***에 대응하는 옵션을 사용할 수 있다.
  * 옵션을 지정하는 문자 뒤에 콜론(:)이 있으면 옵션값을 받는다는 의미이다. (ex ./shell.sh -a hello)
  * 콜론이 없으면 옵션 명을 받을 변수 없이 옵션을 사용할 수 있다. (ex ./shell.sh -h)
 
* **varname** 부분은 옵션 명을 받을 변수를 지정한다.
  * shell.sh 파일에서 11번째 라인을 보면 `while getopts "a:b:h" opt` 라고 작성하였다.
  * opt로 옵션명을 받아서 옵션명의 케이스에 따라 while문이 실행된다. (ex ./shell.sh -a hello   <<- a 옵션이 opt의 인자로 넘어가서 while문이 실행됨.)
  * OPTARG 변수에는 옵션 뒤의 값이 들어간다. (ex ./shell.sh -a hello   <<- hello 옵션이 AOPARG 인자로 넘어간다.)

### **2. getopt**

getopt 옵션은 getopts 옵션의 한계를 보완한 명령어이다.

getopts 명령어는 -a -b h 등과 같은 알파벳 한글자의 명령어들로 사용이 된다.

만약 shell.sh 파일에서 **option_string** 부분에 `while getopts "a:b:hello:h" opt` 라고 선언을 해도

./shell.sh -hello person 을 입력하여 실행을 한다면 정상적인 입력이 아니라고 판단해 help함수를 실행해줄 것이다.

getopt 명령어를 사용해 명령어를 길게 작성할 수도 있다.

```sh
#!/bin/bash

if ! options=$( getopt -o a:bh -l hello,help,name: -- "$@" )
then
        echo "ERROR!!"
        exit 1
fi

eval set -- "$options"

while true
do
        case "$1" in
                -h|--help)
                echo "help() excute"
                shift ;;
                -a|--name)
                name=$2
                echo "hello $name!!"
                shift 2 ;;
                -b|--hello)
                echo "Hello World!!"
                shift ;;
                --)
                shift 2
                break
        esac
done
```

getopt 명령어는 `getopt -o shortopts -l longopts -n progname parameters` 로 구성된다.

* **shortopts**
  * 옵션을 정의하는 문자
  * 짧은 옵션만 가능함
  * 구분자가 없다

* **longopts**
  * 옵션을 정의하는 문자
  * 긴 옵션이 가능하다
  * 한글자로 구분을 할 수 없기때문에 구분을 할때 콤마(,)를 사용해서 구분을 한다

* **progname**
  * 오류 발생시 프로그램의 명칭을 알려준다
  * getopt.sh 파일에서는 getopt.sh를 출력해줌

* **parameters**
  * 옵션에 해당하는 실제 명령 구문이 들어간다
  * 보통은 모든 파라미터를 뜻하는 "$@"를 사용한다

이렇게 getopt 명렁어를 사용하여 getopts에서 사용할 수 없었던 긴단어의 명령어를 만들수 있기 때문에

한글자의 명령어보다 조금더 직관적으로 이해가 되는 명령어를 만들때 유용하게 사용할 수 있는 명령어이다.

### **3.sed**

sed 명령어는 파일명을 인자로 받아서 명령어를 통해 작업한 후 결과를 화면에 출력해주는 명령어이다.

sed 명령어는 편집기의 기능도 가지는데 sed 명령어로 파일을 변경했을때의 특징은, sed 편집기는 **원본파일을 손상하지 않는다**는 것이다.

![ScreenShot_20211116174039](https://user-images.githubusercontent.com/71830573/141951673-511b4da9-0abe-4078-849b-2dcf90792819.jpeg)

[출처] (https://snipcademy.com/shell-scripting-sed#the-hold-buffer-space)

위 사진은 sed 명령어가 동작할때 사용되는 두개의 워크스페이스를 그림으로 표현한 것이다.

두개의 워크 스페이스는 패턴 스페이스와 홀드 스페이스로 구성된다.

* **패턴버퍼**(=패턴 스페이스)
  * 패턴버퍼는 sed가 파일을 라인단위로 읽을 때 그 읽힌 라인이 저장되는 임시 공간이다.
  * 우리가 sed 명령어를 통해 출력을 하면 패턴버퍼에 있는 내용이 출력이되고 편집을 할때도 패턴버퍼에 있는 내용이 편집이된다.
    * **원본에 직접적인 영향을 미치지 않는다.**

* **홀드버퍼**(=홀드 스페이스)
  * 홀드버퍼는 패턴버퍼와는 다르게 작업중인 내용을 장기적으로 저장할 수 있는 공간이다.
    * 즉 어떤 내용을 홀드버퍼에 저장하면 sed가 다음 행을 읽더라도 원할때 저장된 내용을 불러와서 재사용 할 수 있다.

sed 명령어는 받을수 있는 옵션이 매우 많다. 그중에서도 자주 사용하는 옵션들을 정리해보았다.

|명령어|기능|예시|
|------|---|---|
|p|출력|sed p 파일명:파일 전체 출력(cat과 같은 기능)|
|||sed 3p 파일명:3번째 줄 한번 더 출력|
|||sed 3,4p 파일명:3,4번째 줄 한번 더 출력|
|||sed /hello/p 파일명:hello가 포함된 줄 한번 더 출력|
|||sed -n 3p 파일명:3번째 줄만 출력(-n이 붙으면 조건에 해당하는 줄만 출력됨)|
|d|삭제|sed 3d 파일명:3번째 줄 삭제하고 나머지 줄 출력|
|||sed /hello/d 파일명:hello가 포함된 줄 삭제 나머지 줄 출력|
|s|치환|sed 's/hello/bye/g' 파일명:hello를 bye로 치환|
|||sed -n 's/hello/bye/p' 파일명:hello를 bye로 치환하고 치환된 줄을 출력|

　

sed 옵션에서 주로 쓰는것은 **-n** 옵션인데 -n옵션은 특정 조건이 만족하는 문장만을 출력해주는 옵션이다. 보통 p명령어와 사용한다.

또다른 옵션으로는 -f 옵션이 있는데 스크립트를 파일로부터 읽어들여 명령어를 지정하는 명령어이다.
