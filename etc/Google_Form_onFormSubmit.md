# 구글 폼 onFormSubmit()

구글 폼을 이용해 **휴가 신청서를 생성 및 제출**하고, **제출과 동시에** 담당자에게 신청서의 내용을 담은 **이메일이 발송**되도록 구현해보겠습니다.

=> [구글 폼 사이트](https://docs.google.com/forms/create?hl=ko)

구글 폼을 작성할 수 있는 사이트가 열립니다.   

> <h3>휴가 신청서 양식 만들기</h3>

먼저 `[질문]` 탭의 각 항목을 확인해봅시다.   
![image](https://user-images.githubusercontent.com/43658658/154258166-300be374-f7fd-49f2-8689-b0699961fd4d.png)   
- 1 : 구글 폼 파일 이름
- 2 : 구글 폼의 제목과 설명
- 3 : 설문지의 조항 제목
- 4 : 설문지 조항의 종류
- 5 : 설문지 조항 추가

`[설정]` 탭으로 들어갑니다.

`이메일 주소`를 수집하기 위해 해당 항목을 활성화합니다.   
![image](https://user-images.githubusercontent.com/43658658/154260110-ed970470-f836-4ed5-9b7a-6d7bf3bc0fb8.png)   
- `[질문 탭]`의 최상단에 이메일을 입력하는 항목이 추가됩니다.   
![image](https://user-images.githubusercontent.com/43658658/154260246-2a9da915-d29b-4312-a768-2d20bab258f9.png)

다시 `[질문]` 탭으로 돌아와서 항목을 구성합니다.   
![image](https://user-images.githubusercontent.com/43658658/154261289-0c506cf3-bcc4-4dc5-a1c0-633872dde81f.png)

이제 `[응답]` 탭으로 들어갑니다.

응답 내용을 `구글 스프레드시트`로 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/154258551-7dead7cc-0227-4244-84fa-fabf4e3dda38.png)   

`새 스프레드시트`를 만듭니다.   
![image](https://user-images.githubusercontent.com/43658658/154258700-880647b9-0d31-4539-b98f-a8a9f12e2469.png)

새로운 탭으로 **구글 스프레드시트**가 만들어집니다.   
![image](https://user-images.githubusercontent.com/43658658/154261409-a28e864e-d743-43bc-8282-90dc26fd6d64.png)   
- 셀의 1행에는 `[질문 탭]`에서 생성한 조항들의 제목이 차례대로 들어갑니다.

> <h3>이메일 본문 내용 작성</h3>

구글 스프레드시트 좌측 하단의 `+` 버튼을 눌러 시트를 하나 생성합니다.   
![image](https://user-images.githubusercontent.com/43658658/154262533-969341e9-ed32-44be-8d00-e93177dd76be.png)

시트 이름은 `메일본문내용`이라고 하겠습니다.   
![image](https://user-images.githubusercontent.com/43658658/154262629-3e08ecf1-83b7-4038-bd61-055bec148391.png)

이제 시트의 `A1`에 원하는 본문 내용 형식을 작성합니다.   
```
{name}님으로부터 휴가 신청이 접수 되었습니다.

휴가 신청 날짜 :
{start} ~ {end}

사유 :
{comment}
```   
![image](https://user-images.githubusercontent.com/43658658/154262820-327d4281-13a5-4c89-b5c7-3f7fc53fd4bb.png)   
- `{name}, {start}, {end}, {comment}`에는 각각 `이름, 휴가 시작일, 휴가 종료일, 사유`가 들어갈 예정입니다.
- 이후 `Apps Script`에서 구현할 것입니다.

> <h3>이메일 발송 코드 작성</h3>

**구글 스프레드시트**에서 `확장 프로그램 > Apps Script`로 접근합니다.   
![image](https://user-images.githubusercontent.com/43658658/154262015-6d11346e-78dd-4f63-94f1-aca094d852f9.png)

아래의 `javascript` 코드를 작성합니다.   
``` javascript
function onFormSubmit(e) {

  var templateText = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("메일본문내용").getRange(1, 1).getValue();

  var messageBody = templateText.replace("{name}", e.values[2]).replace("{start}", e.values[3]).replace("{end}", e.values[4]).replace("{comment}", e.values[5]);

  MailApp.sendEmail("khyup0629@gmail.com", "[휴가 신청] " + e.values[2] + "님으로부터 휴가 신청이 접수되었습니다.", messageBody);

}
```   
![image](https://user-images.githubusercontent.com/43658658/154266639-8835e4ae-975e-464f-8858-19dd7cbfa8c0.png)

- 먼저 함수 이름은 `onFormSubmit`이고, 함수의 인자 `e`는 설문지 항목의 답변들이 리스트 형태로 들어갑니다.   
![image](https://user-images.githubusercontent.com/43658658/154263763-4f258782-7d2e-402b-9b5b-daa6fc016df6.png)   
구글 스프레드시트 기준 맨 왼쪽부터 `인덱스 0`부터 시작합니다.   
- 설문지 항목의 답변은 `e.values[인덱스 번호]`의 형태로 얻을 수 있습니다.
- `templateText`에는 **메일본문내용** 시트의 `A1`의 내용이 들어갑니다.
  - `SpreadsheetApp`는 구글 스프레드시트 라이브러리입니다. `getSheetByName(<시트이름>)`을 이용해 **메일본문내용** 시트를 불러오고, `getRange(1, 1)`을 이용해 `A1`을 가리키고, `getValue()`를 이용해 값을 불러옵니다.
- `messageBody`에는 가공된 메일 본문 내용이 들어갑니다.
  - `templateText`의 문자열에서 `replace` 함수를 이용해 `{name}, {start}, {end}, {comment}`를 각각 설문지 답변 내용인 `이름, 휴가 시작일, 휴가 종료일, 사유`로 변경해줍니다.
- `MailApp.sendEmail("전송할 메일 주소", "메일 제목", "메일 본문 내용")`으로 메일을 전송합니다.

제목을 변경하고, `프로젝트 저장` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/154265092-6fef2f54-289c-4fab-83e5-b7bb1bcb6b5f.png)

그럼 `실행`, `디버그` 버튼이 활성화되고, `함수 이름`이 표시됩니다.
![image](https://user-images.githubusercontent.com/43658658/154265178-f2474e4a-7db1-4aab-a225-220e92800d8a.png)

> <h3>제출 트리거 설정</h3>

`Apps Script` 왼쪽 네비게이션 바에서 `시계` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/154265406-a41146c4-ff12-49c1-a7d2-2d062497726b.png)

우측 하단의 `트리거 추가` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/154265474-7acb8eaa-6861-4570-b715-9c6a22c891ea.png)

아래와 같이 설정하고 `저장` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/154265547-cdee0c2f-8cc0-469f-8ddf-b6c781eb0df0.png)

아래와 같이 권한을 주는 윈도우 창이 나타납니다.   
![image](https://user-images.githubusercontent.com/43658658/154265712-856745a3-047c-456e-9ccb-c2ad15434a0a.png)   
![image](https://user-images.githubusercontent.com/43658658/154265770-85f917a4-3e87-408d-8e22-d4cafad8038d.png)   
![image](https://user-images.githubusercontent.com/43658658/154265823-caa4a650-933f-437a-912b-97b719eb959d.png)

`트리거`가 추가되었습니다.   
![image](https://user-images.githubusercontent.com/43658658/154265898-31956920-071a-4e15-ac05-da518ba3545a.png)

> <h3>테스트</h3>

자! 이제 마지막으로 테스트를 할 시간입니다.

다시 `구글 폼`으로 돌아옵니다.

우측 상단의 `보내기` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/154266000-575a9b07-1e41-4ba1-8d04-da48906fe2f5.png)

링크를 복사합니다.   
![image](https://user-images.githubusercontent.com/43658658/154266164-c81a3933-8911-4755-830a-aa72e90e67e5.png)

새로운 브라우저 창을 열어서 링크로 들어가서 아래와 같이 신청서를 작성한 뒤 `제출` 버튼을 누릅니다.   
![image](https://user-images.githubusercontent.com/43658658/154266389-88f380cf-5208-48cf-9805-32840cf60bd3.png)   
![image](https://user-images.githubusercontent.com/43658658/154266451-86beb808-a0c0-4c16-98e0-5b0009f6e032.png)

`Apps Script`로 돌아와 왼쪽 네비게이션 바에서 `실행` 버튼을 눌러 들어가면 트리거의 `성공` 혹은 `실패` 여부를 알 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/154266967-380ad852-e6af-4ec1-b3d0-4ffbeb8efe3a.png)

스크립트에서 입력했던 메일 주소로 들어가면 휴가 신청 메일이 온 것을 확인할 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/154267158-72a332e1-b425-4aaa-8ce5-94771f907252.png)

구글 스프레드시트에는 설문지 답변 내용에 대한 데이터가 차곡차곡 쌓입니다.   
![image](https://user-images.githubusercontent.com/43658658/154267353-f194b0ab-403c-4e47-b67c-6a6235d349dc.png)




