# THUNews
Spider for crawling http://news.tsinghua.edu.cn/

## Setup

```
pip install -r requirements.txt
```

## Crawl data

### Run spider

```
cd thuspider
scrapy crawl thuspider -o ../data.db -t sqlite
```


### Generate inverted list

```
python inverted.py
```


### Run server

```
cd THUNews_website
python manage.py runserver
```
