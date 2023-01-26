FROM python:3.9-slim as dependencies

WORKDIR /opt
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
	    build-essential \
		gcc && \
	python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install -r requirements.txt


FROM python:3.9-slim

RUN groupadd -g 999 python && \
    useradd -r -u 999 -g python python && \
	mkdir /opt/app && \
	chown python:python /opt/app

WORKDIR /opt/app
COPY --chown=python:python --from=dependencies /opt/venv ./venv
COPY --chown=python:python . .
RUN chmod +x main.py

USER python
ENV PATH="/opt/app/venv/bin:$PATH"
EXPOSE 5000

CMD ["uwsgi", "--http", ":5000", "--wsgi-file", "main.py", "--callable", "app"]
