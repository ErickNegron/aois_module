# Use an official Python runtime as a parent image
FROM python:3.11-bookworm

ENV APP_HOME /app
# Install dependencies
RUN apt-get update && apt-get install -y \
	libgl1-mesa-dev \
	&& rm -rf /var/lib/apt/lists/*

ADD --chmod=755 https://astral.sh/uv/install.sh /install.sh
RUN /install.sh && rm /install.sh

WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

COPY bin/uv /usr/local/bin/uv

RUN chmod +x /usr/local/bin/uv

#Adding ability for dockerfile to read 
COPY /Users/ericknegron/.local/bin/uv /path/in/container/uv

# Install python package
RUN /Users/ericknegron/.local/bin/uv pip install --system --no-cache -e .

#Expose uvicorn/fastapi
EXPOSE 8002

# Run entrypoint script when the container launches
CMD ["uvicorn", "pupil_labs.aois_module._defineAOIs:app", "--host", "0.0.0.0", "--port", "8002"]

