## 프로메테우스 쿼리(PromQL)

> <h3>인스턴트 벡터 selector</h3>

- 인스턴트 벡터의 label에 대해 **원하는 value**로 필터링을 하는 쿼리
- 중괄호(`{}`)에 입력합니다.
- ex) prometheus_engine_query_duration_seconds_count{instance='<ip 주소:포트번호>'}

> <h3>레인지 벡터 selector</h3>

- 레인지 벡터의 label에 시간을 입력해서 원하는 개수 만큼의 **metric value**를 select하는 쿼리
- 대괄호(`[]`)에 입력합니다.
- ex) prometheus_engine_query_duration_seconds_count[1m]

> <h3>offset</h3>

- 현재 시점에서 **몇 시간 전의 샘플**들을 select하는 쿼리
- ex) prometheus_engine_query_duration_seconds_count offset 1m

> <h3>by (label)</h3>

- **operation과 연계**하여 label을 그룹별로 볼 수 있습니다.
- ex) count (prometheus_engine_query_duration_seconds_count) **by** (instance)

> <h3>without (label)</h3>

- 명시한 label을 제외한 label들을 그룹별로 묶은 값을 쿼리합니다.
- ex) count (prometheus_engine_query_duration_seconds_count) **without** (instance)

> <h3>join</h3>

각 샘플들의 metric value를 label 별로 사칙연산을 수행할 수 있습니다.

사칙연산을 수행하는 샘플의 개수가 많은 것을 **카디널리티가 높다**라고 표현합니다.

> <h3>on과 ignoring</h3>

- on(label) : 명시한 label만 가지고 join
- ignoring(label) : 명시한 label를 무시하고 join

> <h3>group_left, group_right</h3>

카디널리티가 높은 인스턴트 벡터를 join의 왼쪽에 둘 경우 **group_left**를 써줍니다.   
카디널리티가 높은 인스턴트 벡터를 join의 오른쪽에 둘 경우 **group_right**를 써줍니다.

ex) prometheus_engine_query_duration_seconds_count / on (instance, job) **group_left** prometheus_engine_queries_concurrent_max
