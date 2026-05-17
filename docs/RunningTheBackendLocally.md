1. Run the backend  (main.py) with this command 

```uvicorn main:app --host 0.0.0.0 --port 8000 --reload```

2. Change base URL in Frontend/lib/Services/backend_service to your IPv4 address (find it via ``ipconfig``) so it becomes ``"http://<your_ip_address>:8000"``
4. pray
