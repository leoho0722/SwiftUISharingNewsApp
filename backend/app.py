import json
from dotenv import load_dotenv

import helper
from data_models import (
    NewsRequest,
    NewsResponse,
)
from news_service import NewsService
from response_builder import build_response

load_dotenv()


def lambda_handler(event, context):
    helper.debug_print("Event: {}".format(event))

    # 1. 解析 event 內容
    # 如果 event 是字串，嘗試將其解析為 JSON
    if isinstance(event, str):
        event = json.loads(event or "{}")
        helper.debug_print("Raw Request Body: {}".format(event))

    # 如果 event 是字典，直接使用
    if isinstance(event, dict):
        helper.debug_print("Raw Request Body: {}".format(event))

    # 2. 從 requestContext 判斷 HTTP Method
    request_context = event.get("requestContext", {})
    http = request_context.get("http", {})
    method = http.get("method", "GET")

    request = None
    response = None

    # 3. 根據 HTTP Method 取得參數
    match method:
        case "POST":
            body = event.get("body")
            if isinstance(body, str):
                body = json.loads(body or "{}")
                helper.debug_print("Parsed Request Body: {}".format(body))
            elif isinstance(body, dict):
                helper.debug_print("Parsed Request Body: {}".format(body))
            else:
                body = {}
            request = NewsRequest.from_dict(body)
        case "GET":
            request = NewsRequest()
        case _:
            response = NewsResponse(news_items=[], error_message="Method Not Allowed")
            return build_response(405, response.to_dict())

    # 4. 呼叫 NewsService 搜尋新聞
    news_service = NewsService()
    response = news_service.fetch_news(request)
    helper.debug_print("News Response: {}".format(response.to_dict()))

    # 5. 回傳 Response
    # 如果 response 有 error_message，則回傳 500，否則回傳 200
    status_code = 500 if response.error_message else 200
    return build_response(status_code, response.to_dict())


if __name__ == "__main__":
    test_event = {"requestContext": {"http": {"method": "GET"}}}
    result = lambda_handler(test_event, None)
    print("Lambda Result:", result)
