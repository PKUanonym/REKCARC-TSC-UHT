from django import forms

class checkForm1(forms.Form):
    area = forms.CharField(max_length = 100)

# class checkForm2(forms.Form):
#     start_time = forms.DateTimeField(null=False)
#     end_time = forms.DateTimeField(null=False)
#     area = forms.CharField(max_length=100)