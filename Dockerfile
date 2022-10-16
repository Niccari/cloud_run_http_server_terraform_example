FROM python:3.9

ENV APP_HOME /app

WORKDIR $APP_HOME
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD exec uvicorn main:app --host 0.0.0.0 --port 8080
