# Service Level Objectives (SLO) — Agama Service

Agama is a web application exposed over HTTP. Reliability of the main page is critical for both availability and user-perceived latency. Logs are collected via **HAProxy access logs** and shipped to **Loki** using Promtail. SLIs and SLOs are derived from this log data.

## User Journey 1: Main Page Availability

**Description:** A user accesses the main Agama page and expects it to load successfully.

### SLI Type
Availability

### SLI Specification
- **Event:** HTTP request to the main Agama page through HAProxy load balancer
- **Success:** HTTP status codes **2xx or 3xx**  
- **Failure:** HTTP status codes **4xx or 5xx**  
- **Log Source:** HAProxy ring buffer → Promtail TCP syslog (port 8814)

### SLI Implementation
- **Data Source:** Loki  
- **Recorded via:** HAProxy logs shipped by Promtail via syslog
- **Log Format:** `%ST %Tr` (status_code response_time_ms)
- **Calculation:**
```logql
Availability = 100 * (
  sum(rate({job="haproxy"} |~ "\\d{3} \\d+" |~ "[23]\\d\\d " [7d]))
  /
  sum(rate({job="haproxy"} |~ "\\d{3} \\d+" [7d]))
)
```

### SLO 
- **Target:** 99% availability
- **Measurement Window:** 7 days

---

## User Journey 2: Main Page Latency

**Description:** A user opens the main page and expects a fast response.

### SLI Type
Latency

### SLI Specification
- **Event:** HTTP request to the main Agama page through HAProxy load balancer
- **Success:** Request latency <= 500 ms
- **Failure:** Request latency > 500 ms
- **Log Source:** HAProxy ring buffer → Promtail TCP syslog (port 8814)

### SLI Implementation
- **Data Source:** Loki
- **Recorded via:** HAProxy logs shipped by Promtail via syslog
- **Log Format:** `%ST %Tr` (status_code response_time_ms)
- **Average Latency Calculation:**
```logql
avg(
  avg_over_time(
    {job="haproxy"}
    |~ "\\d{3} \\d+"
    | regexp "(?P<status_code>[0-9]{3}) (?P<request_time>[0-9.]+)"
    | unwrap request_time
    [7d]
  )
)
```
- **Latency SLI Calculation:**
```logql
Latency SLI = 100 * (
  sum(count_over_time({job="haproxy"} |~ "\\d{3} \\d+" | regexp "(?P<status_code>[0-9]{3}) (?P<response_time>[0-4]?[0-9]{1,2}|500)\\b" [7d]))
  /
  sum(count_over_time({job="haproxy"} |~ "\\d{3} \\d+" [7d]))
)
```

### SLO
- **Target:** 95% of requests complete within 500 ms
- **Measurement Window:** 7 days

---
