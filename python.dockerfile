FROM python:3.9

WORKDIR /usr/src/app/flask

RUN apt-get update && apt-get install tesseract-ocr -y
RUN apt-get install python3-opencv -y

COPY ./python/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN pip install opencv-python

COPY ./python .
