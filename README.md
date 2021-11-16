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
  * 보통은 모든 파라미터를 뜻하는 $@를 사용한다

이렇게 getopt 명렁어를 사용하여 getopts에서 사용할 수 없었던 긴단어의 명령어를 만들수 있기 때문에

한글자의 명령어보다 조금더 직관적으로 이해가 되는 명령어를 만들때 유용하게 사용할 수 있는 명령어이다.
