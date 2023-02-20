# 問答網

## 系統環境
有賴於 Laradock，目前已經將 Laradock 專案放置到 QA 內部，也就是 QA 專案本身會自帶開發環境，路徑位於 `/laradock`。我們已經填寫了基本的設定，只需要啟動後簡單複製即可。
- PHP 8.1
- Nginx
- Mongo
- Redis

## 安裝步驟

1. 下載
````
git clone git@github.com:pi-tw/jobar.git jobar
````

2. 修改環境設定
    ````
    cd qa-site
    cd laradock
   
    cat .env.example .env.self > .env
    
   # 複製 Laravel 設定檔
    cd ..
   cp .env.example .env
   ````

    - Local

    - Stage
      ```
      ```


    - Production
      ```
      ```
      (待補)

3. 啟動相關服務
    ````shell
    cd laradock
    docker-compose build nginx php-fpm workspace
    docker-compose up -d nginx php-fpm workspace
    # 如果透過快取安裝出錯，可以刪除所有 docker images 
    docker system prune -a
    # 如果發生錯誤，可嘗試清除緩存如 
    docker-compose build --no-cache [你要啟動的容器]
    ````

   讓 crontab 自動部署可以避免抓不到 composer
    ```shell
    docker-compose exec workspace bash
    # 使用 root 身份修改
    vim /etc/cron.d/laradock
    ```

    ```shell
    # 加入這行
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/var/www/vendor/bin

    # 下面這行不變
    * * * * * laradock /usr/bin/php /var/www/artisan schedule:run >> /dev/null 2>&1
    ```

       ````

4. 確認專案可以寫入 Log 權限

    - Local, Stage
        ````shell
        cd laradock
      
        # 查詢權限
        docker-compose exec php-fpm id www-data
        # 修改權限
        cd ..
        sudo chown -R 1000:1000 storage
        # 如果 log 仍然沒有寫入的權限，那麼試試看
        sudo chmod -R 777 storage
        ````


5. 依不同環境修改後繼續

   ````shell
   docker-compose exec workspace bash
   
   # 安裝 php 依賴套件
   composer install
   
   # Production 才要運行此行，讓系統進入維護
   php artisan down --retry=60 --secret="vegout"
   
   # Stage 與 Production 才要運行此行
   php artisan optimize
    
   # 開發期間請使用 migrate 與 seed
   php artisan migrate:refresh --seed
    
   # 建立 storage 軟連結，用於存放圖片
   php artisan storage:link
   ````

   ````shell   
   # 安裝 JavaScript 套件，並產生前端資源
   npm install && npm run dev
   
   # Production 才要運行此行，讓系統離開維護模式
   php artisan up
   ````      

   另外，開發期間可使用指令快速初始化專案
   ````
   sh ./develop_system_refresh.sh 
   ````
   
6. 訪問專案
    ````shell
    vim /etc/hosts
    # 打開 hosts 後，加入下面這行
    127.0.0.1 dev.qa.tw
    ````
   嘗試訪問首頁 [https://dev.qa.tw:51601/](https://dev.qa.tw:51601/)
   。應該會遇到安全性阻擋，請參考這篇 [Chrome 繞過自我憑證檢查](https://hackmd.io/@IMQMrPBwRTGAorHojUIIyg/SJgZy65D8#Chrome-%E7%B9%9E%E9%81%8E%E8%87%AA%E6%88%91%E6%86%91%E8%AD%89%E6%AA%A2%E6%9F%A5)。
