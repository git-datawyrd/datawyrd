from django.contrib import admin
from .models import Categoria, Moneda, Pais, Ciudad

# Register your models here.

@admin.register(Categoria)
class CategoriaAdmin(admin.ModelAdmin):
    list_display = ('cod_categoria', 'categoria', 'created', 'updated')
    search_fields = ('cod_categoria', 'categoria')
    list_filter = ('created',)
    ordering = ('categoria',)

@admin.register(Moneda)
class MonedaAdmin(admin.ModelAdmin):
    list_display = ('cod_moneda', 'moneda', 'activo', 'created', 'updated')
    list_filter = ('activo', 'created')
    search_fields = ('cod_moneda', 'moneda')

@admin.register(Pais)
class PaisAdmin(admin.ModelAdmin):
    list_display = ('cod_pais', 'pais', 'moneda', 'created', 'updated')
    search_fields = ('cod_pais', 'pais', 'moneda__moneda')
    list_filter = ('moneda', 'created')
    ordering = ('pais',)

@admin.register(Ciudad)
class CiudadAdmin(admin.ModelAdmin):
    list_display = ('cod_ciudad', 'ciudad', 'pais', 'created', 'updated')
    search_fields = ('cod_ciudad', 'ciudad', 'pais__pais')
    list_filter = ('pais', 'created')
    ordering = ('ciudad',)