# SwiftUI Sharing News App Backend

本專案為 SwiftUI Sharing 讀書會所開發的後端服務，提供衛生福利部新聞查詢 API，並部署於 AWS Lambda 上搭配 API Gateway 使用。

## 專案架構

```text
SwiftUISharingNewsApp/
├── backend/                    # 後端服務
│   ├── app.py                  # Lambda 函數入口點
│   ├── data_models.py          # 資料模型定義
│   ├── news_service.py         # 新聞服務邏輯
│   ├── response_builder.py     # Response Builder
│   ├── helper.py               # 輔助函數
│   ├── requirements.txt        # Python 套件依賴
│   ├── pyproject.toml          # 專案配置檔
│   ├── Dockerfile              # Docker 映像檔建置設定
│   ├── Makefile                # 部署指令腳本
│   ├── .env                    # 環境變數配置檔
│   └── scripts/
│       ├── deploy-image.sh     # Docker 映像檔部署腳本
│       └── update-function.sh  # Lambda 函數更新腳本
└── frontend/                   # 前端應用
```

## 功能說明

### 核心功能

- **新聞查詢**：透過衛福部公開 API 查詢新聞資訊
- **支援 HTTP Methods**：
  - `GET`：取得所有新聞
  - `POST`：依條件篩選新聞
- **查詢參數支援**：
  - `keyword`：關鍵字搜尋
  - `start_date`：開始日期（格式：YYYY-MM-DD 或 YYYY/MM/DD）
  - `end_date`：結束日期（格式：YYYY-MM-DD 或 YYYY/MM/DD）

### 回應格式

#### 成功 (200 OK)

```json
{
    "status_code": 200,
    "news_items": [
        {
            "title": "新聞標題",
            "content": "新聞內容",
            "url": "新聞連結",
            "publish_date": "發布日期",
            "modified_date": "修改日期",
            "attachment_files": [
                {
                "filename": "檔案名稱",
                "file_description": "檔案說明",
                "file_url": "檔案連結"
                }
            ]
        }
    ],
    "error_message": null
}
```

#### 方法不允許 (405 Method Not Allowed)

```json
{
    "status_code": 405,
    "news_items": [],
    "error_message": "Method Not Allowed"
}
```

#### 錯誤 (500 Internal Server Error)

```json
{
    "status_code": 500,
    "news_items": [],
    "error_message": "錯誤描述訊息"
}
```

## 技術架構

```json
{
    "status_code": 500,
    "news_items": [],
    "error_message": "錯誤描述訊息"
}
```

## 技術架構

### 開發語言與框架

- **Python 3.13**
- **主要套件**：
  - `requests`：HTTP 請求處理
  - `python-dotenv`：環境變數管理

### 雲端服務

- **AWS Lambda**：Serverless 函數運算平台
- **AWS ECR**：Docker 容器映像檔儲存庫
- **AWS API Gateway**：API 路由與管理（需額外設定）

### 部署架構

本專案採用 Docker 容器化部署至 AWS Lambda：

1. 使用 `public.ecr.aws/lambda/python:3.13` 作為基礎映像檔
2. 透過 Dockerfile 建置應用程式映像檔
3. 推送至 AWS ECR
4. 更新 Lambda 函數使用新的映像檔

## 本地開發

### 環境需求

- Python 3.13+
- Docker
- AWS CLI
- [uv](https://docs.astral.sh/uv/) - Python 套件與環境管理工具

### 環境建立

本專案使用 `uv` 進行 Python 環境管理。如尚未安裝 uv，請參考 [官方安裝文件](https://docs.astral.sh/uv/getting-started/installation/)。

1. **同步專案依賴並建立虛擬環境**：

    ```bash
    uv sync
    ```

此指令會自動：

- 讀取 `pyproject.toml` 中的依賴設定
- 建立虛擬環境（如不存在）
- 安裝所有必要套件

2. **新增套件**（如需要）：

    ```bash
    uv add <package-name>
    ```

3. **本地測試**：

    ```bash
    uv run app.py
    ```

### 啟用 Debug 模式

```bash
export DEBUG_MODE=1
```

## 部署至 AWS Lambda

### 前置準備

1. 複製 `.envExample` 並重新命名為 `.env`：

    ```bash
    cp .envExample .env
    ```

2. 編輯 `.env` 檔案，設定以下環境變數：

    ```bash
    # Docker 映像檔設定
    IMAGE_NAME=your-image-name
    IMAGE_TAG=latest
    IMAGE_ARCH=linux/amd64
    DOCKERFILE_PATH=Dockerfile

    # AWS 設定
    AWS_LAMBDA_FUNCTION_NAME=your-function-name
    AWS_REGION=your-region
    AWS_ECR_REPOSITORY_URI=your-ecr-uri
    AWS_ACCESS_KEY_ID=your-access-key
    AWS_SECRET_ACCESS_KEY=your-secret-key
    ```

### 部署指令

```bash
# 完整部署（推薦，包含以下兩個步驟）
make deploy

# 建置並上傳 Docker 映像檔至 ECR
make deploy-image

# 更新 Lambda 函數
make update-function
```

## API 使用範例

### GET 請求（取得所有新聞）

```bash
curl -X GET https://your-api-gateway-url/news \
  -H "Content-Type: application/json"
```

### POST 請求（條件查詢）

```bash
curl -X POST https://your-api-gateway-url/searchNews \
  -H "Content-Type: application/json" \
  -d '{
    "keyword": "流感",
    "start_date": "2025-01-01",
    "end_date": "2025-10-31"
  }'
```

## 資料來源

衛生福利部國民健康署

- API 端點：`https://www.hpa.gov.tw/wf/newsapi.ashx`
- 公開資料 API

## 注意事項

- 本專案僅提供後端 API 服務，需搭配 API Gateway 設定才能對外提供服務
- 部署前請確保 AWS Lambda 函數與 ECR Repository 已事先建立
- 日期格式會自動將 `-` 轉換為 `/` 以符合衛福部 API 規範
- 錯誤發生時，回應會包含 `error_message` 欄位並回傳 HTTP 500 狀態碼
