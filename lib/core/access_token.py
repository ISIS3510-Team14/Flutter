from google.oauth2 import service_account
import google.auth.transport.requests

# Ruta a tu archivo credentials.json
credentials_path = "credentials.json"

# Cargar las credenciales de la cuenta de servicio
credentials = service_account.Credentials.from_service_account_file(
    credentials_path,
    scopes=["https://www.googleapis.com/auth/cloud-platform"],
)

# Generar un token de acceso
request = google.auth.transport.requests.Request()
credentials.refresh(request)

print(f"Access Token: {credentials.token}")
