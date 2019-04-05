from rest_framework import serializers
from thunews.models import Thuspideritem


class ItemSerializer(serializers.Serializer):
    title = serializers.SerializerMethodField()
    abstract = serializers.SerializerMethodField()
    date = serializers.SerializerMethodField()
    url = serializers.CharField()

    def get_title(self, item):
        return self.get_content_weight(item.title)[0]

    def get_abstract(self, item):
        paragraphs = filter(lambda x: x, item.content.split('\n'))
        content_weight = map(self.get_content_weight, paragraphs)
        # return paragraph with the highest weight
        return reduce(lambda t1, t2: t1 if t1[1] >= t2[1] else t2,
                      content_weight)[0]

    def get_date(self, item):
        return item.date.split(' ')[0]

    def get_content_weight(self, p):
        """Return (content, weight) tuple for the paragraph.

        `content` is the paragraph with keywords highlighted;
        `weight` is the number of occurrences of the keyword.
        """

        weight = 0
        for k in self.context['keyword_set']:
            weight += p.count(k)
            p = p.replace(k, '<span class="highlighted">%s</span>' % k)

        return (p, weight)
