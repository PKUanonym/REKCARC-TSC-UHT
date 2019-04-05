# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey has `on_delete` set to the desired behavior.
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from __future__ import unicode_literals

from django.db import models


class Thuspideritem(models.Model):
    content = models.TextField()
    date = models.TextField()
    news_id = models.TextField(primary_key=True)
    url = models.TextField()
    title = models.TextField()

    class Meta:
        managed = False
        db_table = 'ThuSpiderItem'


class Inverted(models.Model):
    word = models.TextField(primary_key=True)
    in_title = models.TextField()
    in_content = models.TextField()

    class Meta:
        managed = False
        db_table = 'inverted'
