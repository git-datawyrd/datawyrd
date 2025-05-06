from django.contrib import admin
from .models import LeadContacto
from core.models import Categoria

# Register your models here.


@admin.register(LeadContacto)
class LeadContactoAdmin(admin.ModelAdmin):
    list_display = ('cod_categoria', 'nombre_lead', 'email_lead', 'tlf_lead', 'fecha_contacto')
    search_fields = ('cod_categoria', 'nombre_lead', 'email_lead', 'tlf_lead')
    list_filter = ('cod_categoria', 'fecha_contacto')
    ordering = ('fecha_contacto',)