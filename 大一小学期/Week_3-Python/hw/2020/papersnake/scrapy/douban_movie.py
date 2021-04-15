#!/usr/bin/python3
import os
import sys
import ast
import subprocess
import requests
import json
import re
import time
import threading
from fake_useragent import UserAgent
import MySQLdb
from bs4 import BeautifulSoup
import inspect
import ctypes
import asyncio
import aiohttp

class DouBanMovieSpider:
	def __init__(self):
		self.headers = {
			'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
			'Accept-Encoding': 'gzip, deflate',
			'Accept-Language': 'zh,en;q=0.9,zh-CN;q=0.8,en-US;q=0.7',
			'Cache-Control': 'max-age=0',
			'Connection': 'keep-alive',
			'Upgrade-Insecure-Requests': '1',
			'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36',
		}
		self.ua = UserAgent()
		self.ip_pool = []
		self.proxy = ""
		self.fail = 3
		self.changeIP()
		self.db = MySQLdb.connect("127.0.0.1", "douban", "", "douban", charset='utf8' )
		print(self.db)
		self.execute_list = []
		self.create_movie = "CREATE TABLE IF NOT EXISTS `movie`(id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,title TEXT COMMENT '标题',directors TEXT COMMENT '导演',authors TEXT COMMENT '编剧',actors TEXT COMMENT '主演',datePublished TEXT COMMENT '上映日期',genre TEXT COMMENT '类型',duration TEXT COMMENT '片长',description TEXT COMMENT '剧情简介',comments TEXT COMMENT '评论',info_link TEXT,pic_link TEXT,rate float COMMENT '评分',rate_count NUMERIC COMMENT '评分数',flag NUMERIC)"
		self.create_celebrity = "CREATE TABLE IF NOT EXISTS celebrity(id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,title TEXT COMMENT '姓名',img_url TEXT,info TEXT COMMENT '影人简介',movies TEXT COMMENT '全部作品',actors TEXT COMMENT '合作影人')"
		self.execute_list.append([self.create_movie])
		self.execute_list.append([self.create_celebrity])
		self.commit()
	def __del__(self):
		self.db.close()
	def commit(self):
		self.cur = self.db.cursor()
		for sql in self.execute_list:
			try:
				self.cur.execute(*sql)
			except:
				print("Error",sql)
		self.db.commit()
		self.execute_list.clear()
	def changeIP(self):
		pass
	def get_new_ip(self):
		pass
	async def get_html(self,url,check_url):
		while(True):
			print(url,check_url)
			try:
				async with aiohttp.ClientSession(trust_env=True, headers=self.headers) as session:
					async with session.get(url, timeout=5) as response:
						text = await response.text()
						if check_url in text:
							return text
						else:
							print("Ban")
			except:
				print("Ban")
		
		
	def get_movie_info(self,movie_list):
		jobs = []
		loop = asyncio.get_event_loop()
		for id in movie_list:
			url = "https://movie.douban.com/subject/" + str(id)
			jobs.append(self.get_html(url,"电影"))
		tasks = loop.run_until_complete(asyncio.gather(*jobs))
		for i in range(len(tasks)):
			id = int(movie_list[i])
			response = tasks[i]
			if not response:
				continue
			soup = BeautifulSoup(response,"lxml")
			content = soup.find("script",type="application/ld+json").string.replace("\n","")
			try:
				content = json.loads(content, strict=False)
			except:
				continue
			sql = "replace into movie(id,title,directors,authors,actors,datePublished,genre,duration,description,info_link,pic_link,rate,rate_count,comments,flag) values(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,1)"
			title = content["name"]
			directors = []
			authors = []
			actors = []
			comments = []
			for director in content["director"]:
				url = re.match("/celebrity/(\d+)/",director["url"]).group(1)
				name = director["name"]
				directors.append([url,name])
			for author in content["author"]:
				url = re.match("/celebrity/(\d+)/",author["url"]).group(1)
				name = author["name"]
				authors.append([url,name])
			for actor in content["actor"]:
				url = re.match("/celebrity/(\d+)/",actor["url"]).group(1)
				name = actor["name"]
				actors.append([url,name])
			directors = str(directors)
			authors = str(authors)
			actors = str(actors)
			datePublished = content["datePublished"];
			genre = str(content["genre"]);
			duration = content["duration"]
			description = content["description"]
			info_link = "https://movie.douban.com" + content["url"]
			pic_link = content["image"]
			rate = content["aggregateRating"]["ratingValue"]
			rate_count = content["aggregateRating"]["ratingCount"]
			comment_list = soup.find_all("div",class_="comment")
			for comment in comment_list:			
				try:
					vote = comment.find(class_="votes").text;
					short = comment.find(class_="short")
					info = comment.find(class_="comment-info");
					name = info.find('a').text
					flag = info.find_all('span')[0].text
					star = info.find_all('span')[1].get('class')[0]
					time = info.find(class_="comment-time").get('title')
				except:
					continue
					
				comments.append([name,flag,star,vote,time,short])
			comments = str(comments)
	#		print(sql % (id,title,directors,authors,actors,datePublished,genre,duration,description,info_link,pic_link,rate,rate_count,comments))
			self.execute_list.append([sql , [id,title,directors,authors,actors,datePublished,genre,duration,description,info_link,pic_link,rate,rate_count,comments]])
			if len(self.execute_list) > 8:
				self.commit()
	def get_celebrity_info(self,celebrity_id):
		update_id = []
		for id in celebrity_id:
			self.cur.execute("SELECT id from celebrity where id=%s" , [id])
			celebrity_cursor = self.cur.fetchall()
			if not len(celebrity_cursor):
				update_id.append(id)
		jobs = []
		loop = asyncio.get_event_loop()
		for id in update_id:
			url = "https://movie.douban.com/celebrity/" + str(id)
			jobs.append(self.get_html(url,"影人"))
		tasks = loop.run_until_complete(asyncio.gather(*jobs))
		for i in range(len(tasks)):
			id = int(update_id[i])
			response = tasks[i]
			soup = BeautifulSoup(response,"lxml")
			content = soup.find("div",id="content")
			name = content.find("h1").text
			img_url = content.find("a",class_="nbg").get('href')
			info = content.find("div",class_="bd")
			start = 0
			movies = []
			actors = []
			while(True):
				if(start>=50):
					break
				url = "https://movie.douban.com/celebrity/%d/movies?start=%d&format=text&sortby=vote" % (id,start)
				loop = asyncio.get_event_loop()
				response = loop.run_until_complete(self.get_html(url,"作品"))
				soup = BeautifulSoup(response,"lxml")
				content = soup.find_all("td",headers="m_name")
				if not len(content):
					break
				for item in content:
					movie_url = item.find("a").get('href')
					movie_id = re.search("\d+",movie_url).group(0)
					if movie_id:
						movies.append(movie_id)
				start += 25
			url = "https://movie.douban.com/celebrity/%d/partners" % id
			loop = asyncio.get_event_loop()
			response = loop.run_until_complete(self.get_html(url,"影人"))
			soup = BeautifulSoup(response,"lxml")
			content = soup.find_all("div",class_="info")
			for item in content:
				actor_url = item.find("h2").find("a").get('href')
				actor_id = re.search("\d+",actor_url).group(0)
				actor_cor_info = str(item.find_all("li")[1])
				if actor_id:
					actors.append([actor_id,actor_cor_info])
			info = str(info)
			movies = str(movies)
			actors = str(actors)
			sql = "replace into celebrity(id,title,img_url,info,movies,actors) values(%s,%s,%s,%s,%s,%s)"
			self.execute_list.append([sql , [id,name,img_url,info,movies,actors]])
			if len(self.execute_list) > 8:
				self.commit()
	def auto_get_detail(self,start=0):
		while(True):
			try:
				self.cur.execute("SELECT id,directors,authors,actors,flag from movie where flag=0 order by id limit %s,30" , [start])
			except:
				print("Error",sys._getframe().f_code.co_name)
				print("SELECT id,directors,authors,actors,flag from movie where flag=0 order by id limit 10")
				return
			cursor = self.cur.fetchall()
			movie_update_id = []
			flag = 1
			for item in cursor:
				if item[4] == 0:
					flag = 0
					movie_update_id.append(item[0])
			self.get_movie_info(movie_update_id)
			self.commit()
			if(flag):
				break


spider = DouBanMovieSpider()
spider.auto_get_detail()
