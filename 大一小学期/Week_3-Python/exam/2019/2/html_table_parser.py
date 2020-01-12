from html.parser import HTMLParser


class HTMLTableParser(HTMLParser):
    def __init__(
        self,
        decode_html_entities=False,
        data_separator=' ',
    ):

        HTMLParser.__init__(self)

        self._parse_html_entities = decode_html_entities
        self._data_separator = data_separator

        self._in_td = False
        self._in_th = False
        self._in_h3 = False
        self._current_table = []
        self._current_row = []
        self._current_cell = []
        self.tables = []
        self._current_letter = ''

    def handle_starttag(self, tag, attrs):
        if tag == 'td':
            self._in_td = True
        if tag == 'th':
            self._in_th = True
        if tag == 'h3':
            self._in_h3 = True

    def handle_data(self, data):
        if self._in_td or self._in_th:
            self._current_cell.append(data.strip())
        if self._in_h3:
            self._current_letter = data

    def handle_charref(self, name):
        if self._parse_html_entities:
            self.handle_data(self.unescape('&#{};'.format(name)))

    def handle_endtag(self, tag):
        if tag == 'td':
            self._in_td = False
        elif tag == 'th':
            self._in_th = False
        elif tag == 'h3':
            self._in_h3 = False

        if tag in ['td', 'th']:
            final_cell = self._data_separator.join(self._current_cell).strip()
            self._current_row.append(final_cell)
            self._current_cell = []
        elif tag == 'tr':
            self._current_table.append(self._current_row)
            self._current_row = []
        elif tag == 'table':
            self.tables.append(
                {'letter': self._current_letter, 'table': self._current_table})
            self._current_table = []
