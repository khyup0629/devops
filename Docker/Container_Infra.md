# 컨테이너 인프라 환경

컨테이너(Container) : 하나의 OS 커널에서 다른 프로세스의 영향을 받지 않고 독립적으로 실행되는 프로세스.

## 모놀로식 아키텍쳐(Monolithic Architecture)

- 하나의 큰 목적이 있는 서비스 또는 애플리케이션에 여러 기능이 통합돼 있는 구조.

![image](https://user-images.githubusercontent.com/43658658/151093356-729c6f21-e231-495c-a93f-d2ef3270872b.png)   

> <h3>장점</h3>

- S/W가 하나의 결합된 코드로 구성되기 때문에 초기 단계에서 설계가 용이.
- 서비스가 별로 없다면 개발이 좀 더 단순하고 코드 관리가 간편.

> <h3>단점</h3>

- 수정이 필요할 경우, 어떤 서비스의 수정이 연관된 다른 서비스에 영향을 미칠 가능성이 매우 큼.
- 서비스가 추가될 수록 처음에는 단순했던 서비스 간의 관계가 매우 복잡해짐.
- 서버 확장 시 특정 서비스만 확장할 수 없고, 애플리케이션 전체를 확장해야 하므로, 상당히 비효율적.

## 마이크로 서비스 아키텍쳐(Micro Service Architecture)

- 애플리케이션 내의 서비스들이 독립적으로 동작하고 개별 기능을 하는 서비스를 각각 개발해서 연결.

![image](https://user-images.githubusercontent.com/43658658/151094130-aa75ab00-0c46-43e2-94ed-423369efd727.png)   
- 각 서비스는 API 게이트웨이와 REST API 통신 방식으로 사용자의 요청을 전달.
- `서비스 디스커버리` : 서비스 개수가 고정이 아니므로, 어떤 서비스가 등록돼 있는지 파악하기 위한 기능.
- `이벤트 버스` : 수많은 서비스의 내부 통신을 이벤트로 일원화하고 이를 효과적으로 관리하는 기능.

> <h3>장점</h3>

- 개발된 서비스를 재사용하기 쉽다.
- 서비스 수정 시 연관된 다른 서비스에 영향을 미칠 가능성이 낮다.
- 특정 서비스만 확장 가능.

> <h3>단점</h3>

- 모놀로식 아키텍쳐보다 복잡도가 높다.
- 각 서비스가 통신하는 구조로 설계되었기 때문에 네트워크 호출 횟수 증가로 인한 추가적인 성능 필요.

## 적합한 아키텍쳐는?

구현할 서비스의 종류가 많지 않은 소규모 프로젝트는 `모놀로식 아키텍처`를 선호하는 경향이 있습니다.

하지만, 소규모 프로젝트라도 처음부터 `마이크로 서비스 아키텍처`로 설계하면   
- 기능에 집중한 안정적인 서비스 구현 가능.
- 구현된 서비스 재사용 가능.
- 장기적으로 볼 때, 유지보수 측면에서 매우 유리.

`컨테이너 인프라 환경`에서는 `마이크로 서비스 아키텍처`가 유리합니다.   
![image](https://user-images.githubusercontent.com/43658658/151095837-83bdf127-ae7e-4dc3-8910-b770236e7fea.png)   
- 마이크로 서비스 아키텍처와 1:1로 완벽하게 대응하는 컨테이너.

## 컨테이너 인프라 환경을 지원하는 도구

#### 도커(Docker)

컨테이너 환경에서 독립적으로 애플리케이션을 실행할 수 있도록 컨테이너를 만들고 관리하는 것을 도와주는 도구.   
![image](https://user-images.githubusercontent.com/43658658/151096264-3d6db615-9f18-4a0a-9c37-56b596766b32.png)   

#### 쿠버네티스(Kubernetes)

다수의 컨테이너를 관리, 컨테이너 인프라에 필요한 기능들을 통합·관리(오케스트레이션)하는 솔루션.   
![image](https://user-images.githubusercontent.com/43658658/151096352-2085def4-326d-493f-b6ea-1e2796df2cab.png)

#### 젠킨스(Jenkins)

지속적 통합(CI, Continuous Integration)과 지속적 배포(CD, Continuous Deployment)를 지원합니다.   
- 개발한 프로그램의 빌드, 테스트, 패키지화, 배포 단계를 모두 자동화.
- 개발된 코드의 빠른 적용, 효과적인 관리, 개발 생산성 증가.

![image](https://user-images.githubusercontent.com/43658658/151097226-a4377a5f-aa6b-48f1-9944-cd6a94e09f76.png)

#### 프로메테우스와 그라파나

컨테이너 인프라 환경의 중앙 모니터링 도구.   
- 프로메테우스 : 상태 데이터를 Pull 방식으로 수집.
- 그라파나 : 수집한 데이터를 시각화.

![image](https://user-images.githubusercontent.com/43658658/151097029-016fb364-72df-40f5-9fdf-cafd98e4f9ba.png)

프로메테우스와 그라파나는 컨테이너로 패키징 되어 쿠버네티스 클러스터의 상태를 시각적으로 표현합니다.


