FROM python:3.11.1

ENV POETRY_VERSION 1.3.2
ADD https://install.python-poetry.org ./get_poetry.py
RUN POETRY_VERSION=${POETRY_VERSION} python /get_poetry.py
ENV PATH /root/.local/bin:$PATH
RUN poetry config virtualenvs.create false

WORKDIR /app

COPY poetry.lock pyproject.toml ./
RUN poetry install --no-dev

COPY main.py ./

CMD exec uvicorn main:app --host 0.0.0.0 --port 8080
