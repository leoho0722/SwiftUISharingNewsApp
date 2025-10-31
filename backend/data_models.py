from dataclasses import dataclass
from typing import Any, Dict, List, Optional
from urllib.parse import urlencode


@dataclass
class NewsRequest:
    """新聞搜尋請求

    Parameters:
        keyword (Optional[str]): 關鍵字
        start_date (Optional[str]): 開始日期
        end_date (Optional[str]): 結束日期
    """

    keyword: Optional[str] = None
    """關鍵字"""

    start_date: Optional[str] = None
    """開始日期"""

    end_date: Optional[str] = None
    """結束日期"""

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "NewsRequest":
        """從字典建立 NewsRequest 實例"""

        return cls(
            keyword=data.get("keyword", None),
            start_date=data.get("start_date", None),
            end_date=data.get("end_date", None),
        )

    def to_dict(self) -> Dict[str, Any]:
        """將 NewsRequest 實例轉換為字典"""

        result = {k: v for k, v in vars(self).items()}
        return result

    @staticmethod
    def _is_nonempty_string(value: Optional[str]) -> bool:
        """判斷值是否為非空白的字串"""
        return bool(value and isinstance(value, str) and value.strip())

    def can_build_query_params(self) -> bool:
        """判斷是否可以建立查詢參數"""

        return any(
            [
                self._is_nonempty_string(self.keyword),
                self._is_nonempty_string(self.start_date),
                self._is_nonempty_string(self.end_date),
            ]
        )

    def build_query_params(self) -> str:
        """建立查詢參數

        Returns:
            str: 查詢參數
        """

        params: Dict[str, str] = {}
        if self.keyword:
            params["keyword"] = self.keyword
        if self.start_date:
            params["startdate"] = self._normalize_date(self.start_date)
        if self.end_date:
            params["enddate"] = self._normalize_date(self.end_date)

        return urlencode(params)

    @staticmethod
    def _normalize_date(date_str: str) -> str:
        """將日期中的 '-' 轉為 '/' 以符合外部 API 範例格式"""
        return date_str.replace("-", "/")


@dataclass
class AttachmentFile:
    """附加檔案

    Parameters:
        filename (str): 檔案名稱
        file_description (str): 檔案說明
        file_url (str): 連結位置
    """

    filename: str
    """檔案名稱"""

    file_description: str
    """檔案說明"""

    file_url: str
    """連結位置"""

    def to_dict(self) -> Dict[str, Any]:
        """將 AttachmentFile 實例轉換為字典"""

        result = {k: v for k, v in vars(self).items()}
        return result


@dataclass
class NewsItem:
    """新聞項目

    Parameters:
        title (str): 標題
        content (str): 內容
        url (str): 連結網址
        attachment_files (List[AttachmentFile]): 附加檔案列表
        publish_date (str): 發布日期
        modified_date (str): 修改日期
    """

    title: str
    """標題"""

    content: str
    """內容"""

    url: str
    """連結網址"""

    attachment_files: List[AttachmentFile]
    """附加檔案"""

    publish_date: str
    """發布日期"""

    modified_date: str
    """修改日期"""

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "NewsItem":
        """從字典建立 NewsItem 實例"""

        attachment_files_data = data.get("附加檔案", [])
        attachment_files = [
            AttachmentFile(
                filename=file.get("檔案名稱"),
                file_description=file.get("檔案說明"),
                file_url=file.get("連結位置"),
            )
            for file in attachment_files_data
        ]

        return cls(
            title=data.get("標題", ""),
            content=data.get("內容", ""),
            url=data.get("連結網址", ""),
            attachment_files=attachment_files,
            publish_date=data.get("發布日期", ""),
            modified_date=data.get("修改日期", ""),
        )

    def to_dict(self) -> Dict[str, Any]:
        """將 NewsItem 實例轉換為字典"""

        result = {k: v for k, v in vars(self).items()}
        # 將 attachment_files 轉換為字典列表
        result["attachment_files"] = [
            {k: v for k, v in vars(af).items()} for af in self.attachment_files
        ]
        return result


@dataclass
class NewsResponse:
    """新聞搜尋回應

    Parameters:
        news_items (List[NewsItem]): 新聞項目列表
        error_message (Optional[str]): 錯誤訊息
    """

    news_items: List[NewsItem]
    """新聞項目"""

    error_message: Optional[str] = None
    """錯誤訊息"""

    def to_dict(self) -> Dict[str, Any]:
        """將 NewsResponse 實例轉換為字典"""

        return {
            "news_items": [item.to_dict() for item in self.news_items],
            "error_message": self.error_message,
        }
