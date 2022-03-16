- influxDB v2.1.1 환경 구축(컨테이너)

```
docker run -d --name influxdb -p 8086:8086 influxdb:2.1.1
```

influxDB 1.8 버전 이상 : Flux 쿼리 언어   
- influxQL의 한계를 보완하기 위해 나온 influxDB의 새로운 쿼리 형식

influxDB 1.7 버전 이하 : influxQL 쿼리 언어   
- SQL 기반이지만, union, join과 같은 고급 함수를 이용한 응용이 불가능하여 기능적 제한이 많습니다.

`influxDB 2.x` 버전을 설치하면 웹 브라우저로 해당 IP로 접속 시 `GUI 환경`의 `influxDB 페이지`가 나타납니다.   

`influxDB 페이지`에 첫 접속 시 아래의 내용을 입력해주어야 합니다.   
1. Username 을 입력합니다.
2. Password 을 입력합니다.
3. Organization 을 입력합니다.
4. Bucket 을 입력합니다.

이제 **influxDB**의 `write API`를 통해 매트릭을 원하는 **클라이언트**와 연결해 데이터를 가져와야 합니다.

`Data` 탭으로 들어가면 각 언어 별로 노드를 연결하고 `Write API`를 이용하는 방법이 나와있습니다.   
![image](https://user-images.githubusercontent.com/43658658/158555783-09ccd200-a43d-4d53-8c36-289ce4382327.png)

`Python`을 통해 들어가보면 클라이언트와 연결하고 데이터를 가져오는 방법이 나타나 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/158556888-4ad17f92-3dc6-4372-ba45-20349975d9a1.png)
![image](https://user-images.githubusercontent.com/43658658/158556978-e7f56cac-8cf5-45a6-9940-81c4f2d37c58.png)

클라이언트와 연결하는 부분입니다.   
``` python
from datetime import datetime

from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS

# You can generate an API token from the "API Tokens Tab" in the UI
token = "<API token 명>"
org = "<organization 명>"
bucket = "<bucket 명>"

with InfluxDBClient(url="http://<ip 주소>:8086", token=token, org=org) as client:
```

데이터를 쓰는 방식은 `Option 2`의 **Data Point**를 이용했습니다.   
``` python
write_api = client.write_api(write_options=SYNCHRONOUS)

point = Point("<Measurement(table)의 이름>") \
  .tag("<인덱싱 필드 명>", <인덱싱 필드 값>) \
  .field("<일반 필드 명>", <필드 값 변수>) \
  .time(<시간 변수>)

write_api.write(bucket, org, point)
```   
- `Point()`에는 `Measurement`의 이름을 입력합니다.
- `.tag`에는 인덱싱 필드에 대한 내용이 들어갑니다.
- `.field`에는 일반 필드에 대한 내용이 들어갑니다.
- `.time`에는 `timestamp`에 대한 내용이 들어갑니다.

`Data > Buckets` 탭으로 들어가면 버킷 리스트가 나타납니다.   
![image](https://user-images.githubusercontent.com/43658658/158558215-fec78f07-efef-497d-b7a4-3e7617512841.png)

클라이언트와 제대로 연결하고, DB에 데이터를 제대로 썼다면 아래와 같이 DB에 데이터가 입력된 것을 볼 수 있습니다.   
![image](https://user-images.githubusercontent.com/43658658/158559407-ecb0ff2e-974e-4fa6-acde-933d99350e4c.png)

(Tip!)influxDB는 일반적인 DB에서 사용되는 Database, Table이란 용어 대신 Bucket, Measurement라는 용어를 사용합니다.



- timeShift 함수를 이용해 Flux 쿼리문 작성
- CDN Request 1, 2 금일, 전일, 전주 하나의 대시보드에 표현
- LG CDN 기존 대시보드 Flux 환경으로 마이그레이션
- Hit 대시보드 Alert 설정 및 가독성 높이기`
