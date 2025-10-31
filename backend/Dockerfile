FROM public.ecr.aws/lambda/python:3.13

# 安裝 Python 依賴
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 複製主程式
COPY app.py .
COPY helper.py .
COPY data_models.py .
COPY response_builder.py .
COPY news_service.py .

# Lambda 入口點
CMD [ "app.lambda_handler" ]