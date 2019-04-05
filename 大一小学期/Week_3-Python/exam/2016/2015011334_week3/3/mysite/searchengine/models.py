from __future__ import unicode_literals

from django.db import models
from django.utils.encoding import python_2_unicode_compatible

# Create your models here.

@python_2_unicode_compatible
class Event(models.Model):
    event = models.CharField(max_length=200)
    ttime = models.CharField(max_length=200)
    def __str__(self):
        return self.event