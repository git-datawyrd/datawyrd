from django import forms
from contacto.models import LeadContacto 
from core.models import Categoria

class FormularioLead(forms.ModelForm):
    class Meta:
        model = LeadContacto
        fields = ['cod_categoria', 'nombre_lead', 'email_lead', 'tlf_lead', 'mensaje_lead']
        labels = {
            'cod_categoria': '',
            'nombre_lead': '',
            'email_lead': '',
            'tlf_lead': '',
            'mensaje_lead': '',
        }
        widgets = {
            'cod_categoria': forms.Select(attrs={'class': 'form-control form-field'}),
            'nombre_lead': forms.TextInput(attrs={'class': 'form-control form-field', 'placeholder': 'Nombre Completo'}),
            'email_lead': forms.EmailInput(attrs={'class': 'form-control form-field', 'placeholder': 'Correo electrónico'}),
            'tlf_lead': forms.TextInput(attrs={'class': 'form-control form-field', 'placeholder': 'Número de teléfono'}),
            'mensaje_lead': forms.Textarea(attrs={'class': 'form-control form-field', 'placeholder': 'Mensaje'}),
        }
