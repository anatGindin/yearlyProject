1. Run the backend  (main.py) with this command from the "Backend" folder.

```uvicorn api.main:app --host 0.0.0.0 --port 8000 --reload```

2. Change base URL in Frontend/lib/Services/backend_service to your IPv4 address (find it via ``ipconfig``) so it becomes ``"http://<your_ip_address>:8000"``

3. Congrats, that's all.


## Common Problems:

## Unauthorized
### 1. accountservicekey.json 
Ensure you have the accountservicekey.json per Omri's instruction. This is the **JWT** check.
### 2. Debug Token: 
The appcheck requires a token. Once we publish the app, it will be taken care of by google play. Until then, we use a debug token. 
Once you execute `flutter'