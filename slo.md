# Service Level Objectives (SLO) — Agama Service

Agama is a web application exposed over HTTP. Reliability of the main page is critical for both availability and user-perceived latency. Logs are collected via **Nginx access logs** and shipped to **Loki** using Promtail. SLIs and SLOs are derived from this log data.

## User Journey 1: Main Page Availability

**URL:** `http://193.40.157.25:5180/`  
**Description:** A user accesses the main Agama page and expects it to load successfully.


### SLI Type
Availability

### SLI Specification
- **Event:** HTTP request to the main Agama page  
- **Success:** HTTP status codes **2xx or 3xx**  
- **Failure:** HTTP status codes **4xx or 5xx**  
- **Log Source:** `/var/log/nginx/agama.log`  

### SLI Implementation
- **Data Source:** Loki  
- **Recorded via:** Nginx logs shipped by Promtail
- **Calculation:**
```text
Availability = successful_requests / total_requests
```
### SLO 
- **Target:** 99% availability
- **Measurement Window:** 30 days



## User Journey 2: Main Page Latency

**URL:** `http://193.40.157.25:5180/`
**Description:** A user opens the main page and expects a fast response.

### SLI Type
Latency

### SLI Specification
- **Event:** HTTP request to the main Agama page
- **Success:** Request latency <= 500 ms
- **Failure:** Request latency > 500 ms
- **Log Source:** `/var/log/nginx/agama.log`

### SLI Implementation
- **Data Source:** Loki
- **Recorded via:** Nginx logs shipped by Promtail
- **Calculation:**
```text
Latency SLI = requests_with_latency <= 0.5s / total_requests
```
### SLO
- **Target:** 95% of requests complete within 500 ms
- **Measurement Window:** 30 days
