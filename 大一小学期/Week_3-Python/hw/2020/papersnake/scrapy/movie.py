#在演员数据中加入参演电影
import MySQLdb
import ast
db = MySQLdb.connect("127.0.0.1", "root","", "douban", charset='utf8' )
cur = db.cursor()
print(db)

def fillCelebrity(id,movie):
	cur.execute("SELECT id,movies from celebrity where id=%s" , [id])
	celebrity_cursor = cur.fetchall()
	if not len(celebrity_cursor):
		return
	item = celebrity_cursor[0]
	if len(item[1]):
		item = item[1]
		try:
			item = ast.literal_eval(item)
		except:
			item = []
	else:
		item = []
	for i in item:
		if i[0] == movie[0]:
			return
	item.append(movie)
	item = str(item)
	cur.execute("update celebrity set movies=%s where id=%s" , [item,id])
	return 1
while(True):
	try:
		cur.execute("SELECT id,directors,authors,actors,title from movie where flag=1 order by id limit 1")
	except:
		print("Error")
	
	item = cur.fetchall()[0]
	cele = []
	try:
		content = ast.literal_eval(item[1])
	except:
		print("Error")
		print(item[1])
	else:
		for id,name in content:
			cele.append(id)
	try:
		content = ast.literal_eval(item[2])
	except:
		print("Error")
		print(item[2])
	else:
		for id,name in content:
			cele.append(id)
	try:
		content = ast.literal_eval(item[3])
	except:
		print("Error")
		print(item[3])
	else:
		for id,name in content:
			cele.append(id)
	cele = list(set(cele))
	movie_id = int(item[0])
	movie_name = str(item[4])
	for person in cele:
		fillCelebrity(person,[movie_id,movie_name])
	cur.execute("update movie set flag=2 where id=%s" , [movie_id])
	print(movie_id,"done")
	db.commit()
