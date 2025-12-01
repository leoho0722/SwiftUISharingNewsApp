//
//  NewsItem.swift
//  SwiftUISharingNewsApp
//
//  Created by Leo Ho on 2025/11/1.
//

import Foundation

/// 新聞項目
struct NewsItem: Identifiable, Codable {
    
    /// 新聞項目 UUID
    let id = UUID()
    
    /// 新聞標題
    let title: String
    
    /// 新聞內容
    let content: String
    
    /// 新聞連結
    let url: String
    
    /// 發布日期
    let publishDate: String
    
    /// 修改日期
    let modifiedDate: String
    
    /// 附加檔案
    let attachmentFiles: [AttachmentFile]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case url
        case publishDate = "publish_date"
        case modifiedDate = "modified_date"
        case attachmentFiles = "attachment_files"
    }
}

extension NewsItem {
    
    static var previewValue: Self {
        .init(
            title: "蛇年4招守腰圍  健康迎春過好年",
            content: "<p>&nbsp; &nbsp; &nbsp; 農曆春節到來，容易因飲食過量及久坐導致腰圍增加，進而提高代謝症候群風險。國民健康署提醒民眾，新春之際別忘「瘦腰4秘訣」：均衡飲食、每週運動150分鐘、正確量腰圍（男性&lt;90公分、女性&lt;80公分）、掌握成人健檢機會(自114年起放寬適用年齡至30歲以上）。</p>\r\n<p><strong>認識代謝症候群危險因子</strong></p>\r\n<p>&nbsp; &nbsp; &nbsp; 代謝症候群是許多嚴重慢性疾病的前兆，由5項危險因子組成，包含3高（高血壓、高血糖、高血脂）和2害（腰圍過粗、好的膽固醇不足），只要符合其中3項，即為代謝症候群。其中，腰圍是最容易自我檢測的項目，因此國民健康署建議民眾在春節期間準備好皮尺定期量測，掌握腰圍不失控。</p>\r\n<p><strong>瘦腰</strong><strong>4</strong><strong>秘訣，過年健康不打烊</strong></p>\r\n<p>&nbsp; &nbsp; &nbsp; 為減少罹患代謝症候群的風險，即便在過年期間，也建議保持飲食均衡與足夠的運動量。國民健康署提供4招秘訣，幫助民眾維持良好體態，安心度過佳節。</p>\r\n<p><strong>■秘訣</strong><strong>1</strong><strong>：年菜均衡不過量，健康烹調無負擔</strong></p>\r\n<p>根據「我的餐盤」六口訣：建議每天早晚一杯奶、每餐水果拳頭大、菜比水果多一點、飯跟蔬菜一樣多、豆魚蛋肉一掌心、堅果種子一茶匙，可均衡攝取六大類食物，選擇減油、減糖、減鹽的烹調方式，如：清蒸、水煮、烘烤、清燉、涼拌等，並善用新鮮水果及香辛料增添風味，在享用美食佳餚的同時，也能吃得健康無負擔。</p>\r\n<p><strong>■秘訣</strong><strong>2</strong><strong>：每週</strong><strong>150</strong><strong>分鐘身體活動，舒緩筋骨更健康</strong></p>\r\n<p>除了健康飲食外，適度的運動同樣重要，建議每週進行至少150分鐘的中等強度身體活動，如：健走、跳舞、太極拳、桌球、羽毛球或騎腳踏車，也可搭配伸展操和瑜伽等柔軟度訓練，有助於舒緩緊繃的肌肉，減少腰部脂肪堆積。</p>\r\n<p><strong>■秘訣</strong><strong>3</strong><strong>：學會正確量腰法，腰圍數值好掌握</strong></p>\r\n<p>早晨空腹時自然站立，除去腰部覆蓋的衣物後，將皮尺繞過腰部，通過腹部中線（骨盆上緣與肋骨下緣之間的中點），並確保皮尺與地面平行，緊貼皮膚但不擠壓，維持正常呼吸，在吐氣結束時量取腰圍。此外，成年男性標準腰圍應小於90公分、女性小於80公分，從未量過腰圍者，建議立即測量，檢視自己及家人的腰圍是否超標。</p>\r\n<p><strong>■秘訣</strong><strong>4</strong><strong>：放寬成人健檢年齡，提早發現控健康</strong></p>\r\n<p>自114年起，國民健康署將免費成人健康檢查的適用年齡範圍進一步放寬：30至39歲每5年一次，40至64歲每3年一次，65歲以上每年提供一次檢查。定期健檢可以檢測與代謝症候群相關的指標，如：腰圍、血壓、血糖和血脂等，有助於及早發現潛在的健康問題，並及時進行介入控制，有效守護健康。</p>\r\n<p>&nbsp; &nbsp; &nbsp; 民眾如欲進一步瞭解代謝症候群防治相關資訊，請至國民健康署健康九九+網站(<a title=\"(另開視窗)\" href=\"https://health99.hpa.gov.tw/\" target=\"_blank\" rel=\"noreferrer noopener\">https://health99.hpa.gov.tw/</a>)查詢代謝症候群衛教素材，亦可至慢性疾病防治館(<a title=\"(另開視窗)\" href=\"https://health99.hpa.gov.tw/theme/6\" target=\"_blank\" rel=\"noreferrer noopener\">https://health99.hpa.gov.tw/theme/6</a>)查詢。</p>\r\n<p>&nbsp;</p>\r\n<p><strong>延伸閱讀：</strong></p>\r\n<p><a title=\"(另開視窗)\" href=\"/Pages/List.aspx?nodeid=223\" target=\"_blank\" rel=\"noopener\"><img src=\"/File/Attach/18774/File_25517.png\" alt=\"QR code\" width=\"125\" height=\"125\" />三高防治專區</a></p>\r\n<p><a title=\"(另開視窗)\" href=\"https://health99.hpa.gov.tw/material/3134\" target=\"_blank\" rel=\"noreferrer noopener\"><img src=\"/File/Attach/18774/File_25518.png\" alt=\"QR code\" width=\"125\" height=\"125\" />代謝症候群學習手冊</a></p>",
            url: "https://www.hpa.gov.tw/Pages/Detail.aspx?nodeid=4878&pid=18774",
            publishDate: "2025-01-22",
            modifiedDate: "2025-01-22",
            attachmentFiles: [
                .init(
                    fileName: "圖片1-三高防治專區QR code.png",
                    fileDescription: "圖片1-三高防治專區QR code",
                    fileURL: "https://www.hpa.gov.tw//Pages/ashx/GetFile.ashx?lang=c&type=1&sid=b79ec120bf4b4c4aa01b38a6ab84032a"
                ),
                .init(
                    fileName: "圖片2-代謝症候群學習手冊QR code.png",
                    fileDescription: "圖片2-代謝症候群學習手冊QR code",
                    fileURL: "https://www.hpa.gov.tw//Pages/ashx/GetFile.ashx?lang=c&type=1&sid=7c5e3928aa954442ae264ad1d5ab2667"
                )
            ]
        )
    }
}

/// 附加檔案
struct AttachmentFile: Identifiable, Codable {
    
    /// 附加檔案 UUID
    let id = UUID()
    
    /// 檔案名稱
    let fileName: String
    
    /// 檔案說明
    let fileDescription: String
    
    /// 檔案連結位置
    let fileURL: String
    
    /// 檔案副檔名
    var fileExtension: String {
        return (fileName as NSString).pathExtension
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fileName = "filename"
        case fileDescription = "file_description"
        case fileURL = "file_url"
    }
}
