# 프로메테우스

## 프로메테우스 아키텍쳐

![image](https://user-images.githubusercontent.com/43658658/153833386-7bde0dc0-f0f9-4a70-96ed-1060b9bf635b.png)

> <h3>Prometheus Server</h3>

- 프로메테우스 서버는 TSDB(Time Series DB)라는 LevelDB를 가지고 있습니다.
- 데이터는 Node에 있는 HDD/SDD에 저장됩니다.

> <h3>jobs/Exporters</h3>

- 프로메테우스 서버가 **pull 방식**으로 jobs/exporters에서 매트릭을 가져갑니다.

> <h3>Service Discovery</h3>

- 프로메테우스가 **타겟을 찾는 기술**입니다.
- **kubernetes, file_sd**
- **file_sd** 파일에 타겟을 명시할 수 있습니다.

> <h3>Pushgateway</h3>

- **push 방식** 지원
- cronjob 같은 **수행 시간이 작은 서버**의 경우 서버가 금방 죽습니다.
- 그렇게 되면 프로메테우스가 **지속적으로 pull 방식으로 매트릭을 스크래핑 할 수 없습니다.**
- 그래서 pushgateway에 이러한 서버들의 데이터를 쌓아두고 프로메테우스가 pull 방식으로 pushgateway의 매트릭을 스크래핑합니다.
- 여러 타겟이 외부에 있고, 타겟에 방화벽을 일일이 지정할 수 없을 때 타겟의 매트릭을 pushgateway에 하나로 모아서 프로메테우스가 가져가는 방법으로도 이용할 수 있습니다.

> <h3>Alertmanager</h3>

- alerting을 담당합니다.
- Alertmanager가 여러 앱에 경보를 보냅니다.

> <h3>Data visualization</h3>

- Prometheus Web UI, Grafana, API Clients

## 매트릭 타입

> <h3>Counter</h3>

- **항상 증가**하는 값에 대한 매트릭 타입.
- reset하면 0

> <h3>gauge</h3>

- **up/down**이 가능한 매트릭 타입
- ex) CPU / Memory 사용량

> <h3>Histogram</h3>

- 응답 크기, 요청 기간 등, **start~end 단위의 주기 내**에서 값의 증감을 관찰할 수 있는 매트릭
- 전체 합계를 확인할 수 있는 매트릭
  
> <h3>Summary</h3>

- **Histogram과 같은 역할**을 하는 매트릭 종류.
- 다른 점은 특정 시간 내의 전체 값이나 양을 구성하기 편하다는 점입니다.
  
## 프로메테우스 표현 언어

> <h3>샘플(Sample)</h3>

`process_cpu_seconds_total{instance="localhost:9090", job="prometheus"}                1.09`는 하나의 **샘플**입니다.

```
`process_cpu_seconds_total{instance="localhost:9090", job="prometheus"}                1.09`   
     (metric name)                  (label key=value)                                metric value(scalar)
```

> <h3>인스턴트 벡터(Instant Vector)</h3>

- **동일 시간대**의 **샘플들의 묶음**
- **Operation**을 적용할 수 있습니다.
  - ex) sum, min, max, avg, stddev(분산), stdvar(표준편차), count, count_values, bottomk, topk, quantile

> <h3>레인지 벡터(Range Vector)</h3>

- **하나의 샘플 내**에 **여러 metric value의 묶음**

