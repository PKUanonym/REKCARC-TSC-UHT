# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class Celebrity(models.Model):
    id = models.IntegerField(primary_key=True)
    title = models.TextField(blank=True, null=True)
    img_url = models.TextField(blank=True, null=True)
    info = models.TextField(blank=True, null=True)
    movies = models.TextField(blank=True, null=True)
    actors = models.TextField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'celebrity'
        verbose_name = '人物'
        verbose_name_plural = '人物'


class Movie(models.Model):
    id = models.IntegerField(primary_key=True)
    title = models.TextField(blank=True, null=True)
    directors = models.TextField(blank=True, null=True)
    authors = models.TextField(blank=True, null=True)
    actors = models.TextField(blank=True, null=True)
    datepublished = models.TextField(db_column='datePublished', blank=True, null=True)  # Field name made lowercase.
    genre = models.TextField(blank=True, null=True)
    duration = models.TextField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    comments = models.TextField(blank=True, null=True)
    info_link = models.TextField(blank=True, null=True)
    pic_link = models.TextField(blank=True, null=True)
    rate = models.FloatField(blank=True, null=True)
    rate_count = models.DecimalField(max_digits=10, decimal_places=0, blank=True, null=True)
    flag = models.DecimalField(max_digits=10, decimal_places=0, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'movie'
        verbose_name = '电影'
        verbose_name_plural = '电影'
