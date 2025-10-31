import requests

from data_models import (
    NewsRequest,
    NewsResponse,
    NewsItem,
    AttachmentFile,
)


class NewsService:
    """用於搜尋新聞的 Service"""

    def __init__(self):
        self.url = "https://www.hpa.gov.tw/wf/newsapi.ashx"

    def fetch_news(self, request: NewsRequest) -> NewsResponse:
        """搜尋新聞

        Parameters:
            request (NewsRequest): 新聞搜尋請求

        Returns:
            NewsResponse: 新聞搜尋回應
        """

        if request.can_build_query_params():
            self.url = f"{self.url}?{request.build_query_params()}"

        response = requests.get(self.url)

        if response.status_code != 200:
            return NewsResponse(
                news_items=[], error_message=f"無法取得新聞: {response.status_code}"
            )
        else:
            return self._parse_news_response(response)

    def _parse_news_response(self, response: requests.Response) -> NewsResponse:
        """解析新聞回應

        Parameters:
            response (requests.Response): 新聞回應

        Returns:
            NewsResponse: 新聞搜尋回應
        """

        resp_body = response.json()
        news_items = []
        for item in resp_body:
            news_items.append(
                NewsItem(
                    title=item.get("標題"),
                    content=item.get("內容"),
                    url=item.get("連結網址"),
                    attachment_files=[
                        AttachmentFile(
                            filename=file.get("檔案名稱"),
                            file_description=file.get("檔案說明"),
                            file_url=file.get("連結位置"),
                        )
                        for file in item.get("附加檔案", [])
                    ],
                    publish_date=item.get("發布日期"),
                    modified_date=item.get("修改日期"),
                )
            )
        return NewsResponse(news_items=news_items)
