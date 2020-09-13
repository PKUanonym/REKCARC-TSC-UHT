#在演员数据中添加合作演员
import MySQLdb
import ast
db = MySQLdb.connect("127.0.0.1", "root", "", "douban", charset='utf8' )
cur = db.cursor()
print(db)

def fillCelebrity(id1,id2):
	cur.execute("SELECT actors from celebrity where id=%s" , [id1])
	celebrity_cursor = cur.fetchall()
	if not len(celebrity_cursor):
		return
	item = celebrity_cursor[0]
	if len(item[0]):
		item = item[0]
		try:
			item = ast.literal_eval(item)
		except:
			item = {}
	else:
		item = {}
	if id2 in item:
		item[id2] += 1
	else:
		item[id2] = 1
	item = str(item)
	cur.execute("update celebrity set actors=%s where id=%s" , [item,id1])
	return 1
while(True):
	try:
		cur.execute("SELECT id,directors,authors,actors,title from movie where flag=2 order by id limit 1")
	except:
		print("Error")
	
	item = cur.fetchall()[0]
	movie_id = int(item[0])
	print(movie_id,"start")
	cele = []
	try:
		content = ast.literal_eval(item[1])
	except:
		print("Error")
		print(item[1])
	else:
		for id,name in content[:10]:
			cele.append(id)
	try:
		content = ast.literal_eval(item[2])
	except:
		print("Error")
		print(item[2])
	else:
		for id,name in content[:10]:
			cele.append(id)
	try:
		content = ast.literal_eval(item[3])
	except:
		print("Error")
		print(item[3])
	else:
		for id,name in content[:10]:
			cele.append(id)
	cele = list(set(cele))
	for i in range(len(cele)):
		for j in range(len(cele)):
			if i!=j:
				fillCelebrity(cele[i],cele[j])
	cur.execute("update movie set flag=3 where id=%s" , [movie_id])
	print(movie_id,"done")
	db.commit()
