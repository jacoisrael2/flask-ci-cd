# Etapa base
FROM python:3.11-slim

WORKDIR /app

# Instalar dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código da app
COPY . .

EXPOSE 5000

# Executar o Flask
CMD ["python", "app.py"]

